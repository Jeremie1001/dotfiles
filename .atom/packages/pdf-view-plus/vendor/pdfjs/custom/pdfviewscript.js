// Hides "basic debug information" and other cruft logged by PDFjs
console.log = () => {}

(function(){

window.onload = () => {
  PDFViewerApplicationOptions.set("sidebarViewOnLoad", 0);
  PDFViewerApplicationOptions.set("enableWebGL", true);
  PDFViewerApplicationOptions.set("externalLinkTarget", 4);
  PDFViewerApplicationOptions.set("eventBusDispatchToDOM", true);
  PDFViewerApplicationOptions.set("renderInteractiveForms", false); // TODO: Can these be saved?
  PDFViewerApplicationOptions.set("isEvalSupported", false);
}

function sendMessage(type, data) {
  parent.postMessage({type, data});
}

window.addEventListener("message", event => {
  const type = event.data.type;
  const data = event.data.data;
  switch (type) {
    case "refresh":
      refreshContents(data.filepath);
      return;
    case "setposition":
      scrollToPosition(data);
      return;
    default:
      throw new Error(`Unexpected message type "${type}" received`);
  }
});

const styleObserver = new MutationObserver(handleChangedStyle);
let lastFilepath = undefined;

function handleChangedStyle(_mutationList, observer) {
  if (window.frameElement.style.display === "") {
    observer.disconnect();
    if (lastFilepath !== undefined) {
      const filepath = lastFilepath;
      lastFilepath = undefined;
      refreshContents(filepath);
    }
  }
}

let lastParams = {scale: 1, scrollTop: 0, scrollLeft: 0}
async function refreshContents(filepath) {
  if (typeof filepath !== "string") {
    throw new Error(`Expected string as filepath, got ${filepath}`);
  }

  if (window.frameElement.style.display === "none") {
    // we are not in view; don't bother updating
    lastFilepath = filepath;
    styleObserver.observe(window.frameElement, {
      attributes: true,
      attributeFilter: ["style"],
    });
    return;
  }

  lastParams = getDocumentParams() || lastParams;
  PDFViewerApplication.open(filepath);
  document.addEventListener(
    "pagesinit",
    () => {restoreFromParams(lastParams)},
    {once: true, passive: true}
  );
}

function getDocumentParams() {
  const container = document.getElementById("viewerContainer");
  const params = {
    scale: PDFViewerApplication.pdfViewer.currentScaleValue,
    scrollTop: container.scrollTop,
    scrollLeft: container.scrollLeft,
  };

  // When the PDF is incomplete (e.g., long rebuild), scale will be null. Probably.
  if (params.scale !== null) {
    return params;
  } else {
    return undefined;
  }
}

function restoreFromParams({scale, scrollTop, scrollLeft}) {
  const container = document.getElementById("viewerContainer");
  PDFViewerApplication.pdfViewer.currentScaleValue = scale;
  container.scrollTop = scrollTop;
  container.scrollLeft = scrollLeft;
}

function scrollToPosition({pageIndex, pointX, pointY, origin}) {
  if (typeof pageIndex !== "number") {
    throw new Error("Expected page number");
  }
  const pageView = PDFViewerApplication.pdfViewer.getPageView(pageIndex);

  const clientHeight = PDFViewerApplication.appConfig.mainContainer.clientHeight;
  const clientWidth = PDFViewerApplication.appConfig.mainContainer.clientWidth;

  const height = pageView.div.offsetTop;

  if (origin === "TL") {
    const [, y1,, y2] = pageView.viewport.viewBox;
    pointY = y2 - y1 - pointY;
  }

  const [x, y] = pageView.viewport.convertToViewportPoint(pointX, pointY);

  const percentDown = 0.50;
  const percentAcross = 0.50;

  PDFViewerApplication.pdfViewer.container.scrollTo({
    top: height + y - clientHeight * percentDown,
    left: x - clientWidth * percentAcross,
  });
}

document.addEventListener("pagerendered", evt => {
  const page = evt.detail.pageNumber - 1;
  const pageView = PDFViewerApplication.pdfViewer.getPageView(page);

  pageView.div.onclick = e => {
    const pdfEvent = buildMouseEvent(pageView, e);
    if (pdfEvent !== undefined) {
      sendMessage("click", pdfEvent);
    }
  };

  pageView.div.ondblclick = e => {
    const pdfEvent = buildMouseEvent(pageView, e);
    if (pdfEvent !== undefined) {
      sendMessage("dblclick", pdfEvent);
    }
  };
}, {capture: true, passive: true});

function getPdfPosition(pageView, click) {
  const rect = pageView.canvas.getBoundingClientRect();
  const relX = click.clientX - rect.left;
  const relY = click.clientY - rect.top;
  const [pointX, pointY] = pageView.viewport.convertToPdfPoint(relX, relY);
  const [x1, y1, x2, y2] = pageView.viewport.viewBox;

  if (pointX < x1 || pointX > x2 || pointY < y1 || pointY > y2) {
    return undefined;
  }

  return {
    pointX,
    pointY,
    width: x2 - x1,
    height: y2 - y1,
    pageIndex: pageView.pdfPage.pageIndex
  };
}

function buildMouseEvent(pageView, e) {
  const position = getPdfPosition(pageView, e);
  if (!position) {
    return undefined;
  }

  return {
    position,
    ctrlKey: e.ctrlKey,
    altKey: e.altKey,
    metaKey: e.metaKey,
    shiftKey: e.shiftKey,
    button: e.button,
    buttons: e.buttons,
  };
}

document.addEventListener("click", evt => {
  const srcElement = evt.srcElement;
  if (srcElement.href !== undefined && srcElement.target === "_top") {
    evt.preventDefault();
    sendMessage("link", {href: srcElement.href});
  }
});

})();
