import * as path from "path";
import {PdfEditor} from "./pdf-editor";
import {PdfMouseEvent, PdfPosition} from "./pdfview-api";
import {Emitter} from "atom";

interface Message {
  origin: string;
  data: {
    type: string;
    data: any;
  };
  source: any;
}

export class PdfEditorView {
  element: any;
  editor: PdfEditor;
  ready: boolean;
  events: Emitter;

  constructor(editor: PdfEditor) {
    const frame = document.createElement("iframe");
    frame.setAttribute("id", "pdf-frame");

    this.events = new Emitter();
    this.editor = editor;
    this.element = frame;

    this.ready = false;
    frame.onload = () => {
      this.ready = true;
    };

    window.addEventListener("message", evt => {
      this.handleMessage(evt as any);
    });

    this.setFile(this.filepath);
  }

  sendMessage(type: string, data: any) {
    this.element.contentWindow.postMessage({type, data});
  }

  handleMessage(msg: Message) {
    if (msg.source !== this.element.contentWindow) {
      return;
    }

    const type = msg.data.type;
    const data = msg.data.data;

    switch (type) {
      case "link":
        this.handleLink(data);
        return;
      case "click":
        this.handleClick(data);
        return;
      case "dblclick":
        this.handleDblclick(data);
        return;
      default:
        throw new Error(`Unexpected message type ${type} from iframe`);
    }
  }

  async handleLink({link}: any) {
    if (typeof link !== "string") {
      throw new Error("Expected external link to be a string");
    }
    (await import("electron")).shell.openExternal(link);
  }

  handleClick(clickData: PdfMouseEvent) {
    this.events.emit("click", clickData);
  }

  handleDblclick(clickData: PdfMouseEvent) {
    this.events.emit("dblclick", clickData);
  }

  get filepath() {
    return this.editor.getPath();
  }

  viewerSrc(): string {
    return path.join(__dirname, "..", "vendor", "pdfjs", "web", "viewer.html");
  }

  setFile(filepath: string) {
    const src = `${this.viewerSrc()}?file=${encodeURIComponent(filepath)}`;
    this.ready = false;
    this.element.setAttribute("src", src);
  }

  update() {
    if (this.ready) {
      this.sendMessage("refresh", {filepath: this.filepath});
    } else {
      this.setFile(this.filepath);
    }
  }

  destroy() {
    this.ready = false;
  }

  scrollToPosition(pos: PdfPosition, options?: any) {
    const payload = pos;
    if (options && options.origin) {
      payload.origin = options.origin;
    }
    this.sendMessage("setposition", pos);
  }
}
