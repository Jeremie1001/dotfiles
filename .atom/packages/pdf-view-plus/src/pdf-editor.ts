import * as fs from "fs";
import * as path from "path";
import {File, Disposable, CompositeDisposable} from "atom";
import {PdfEditorView} from "./pdf-editor-view";
import {PdfView, PdfMouseEvent, PdfPosition} from "./pdfview-api";

export class PdfEditor implements PdfView {
  static deserialize({filePath}: any) {
    let isFile = false;
    try {
      isFile = fs.statSync(filePath).isFile();
    } catch (e) {}

    if (isFile) {
      return new PdfEditor(filePath);
    } else {
      console.warn(
        `Could not deserialise PDF view for path ${filePath} because that file no longer exists`
      );
    }
  }

  file: File;
  fileSubscriptions: CompositeDisposable;
  view: PdfEditorView;
  onDidChangeTitleCallbacks: Set<Function>;
  autoReload: boolean;

  subscriptions: CompositeDisposable;

  constructor(filePath: string) {
    this.file = new File(filePath);
    this.fileSubscriptions = new CompositeDisposable();
    this.view = new PdfEditorView(this);
    this.onDidChangeTitleCallbacks = new Set();
    this.autoReload = true;

    this.subscriptions = new CompositeDisposable();

    this.subscribeToFile();
  }

  subscribeToFile() {
    let timerID: number;
    const debounced = (callback: Function) => {
      clearTimeout(timerID);
      timerID = setTimeout(callback, atom.config.get("pdf-view-plus.autoreloadDebounce"));
    };

    this.fileSubscriptions.add(
      this.file.onDidRename(() => {
        // Doesn't seem to work (on Linux at least)
        this.updateTitle();
      }),
      this.file.onDidChange(() => {
        if (this.autoReload) {
          debounced(() => {
            this.view.update();
          });
        }
      }),
      this.file.onDidDelete(() => {
        if (atom.config.get("pdf-view-plus.closeViewWhenFileDeleted")) {
          try {
            this.destroy();
          } catch (e) {
            console.warn(`Could not destroy pane after external file was deleted: ${e}`);
          }
        }
      })
    );
  }

  get element() {
    return this.view.element;
  }

  serialize() {
    return {
      filePath: this.getPath(),
      deserializer: this.constructor.name,
    };
  }

  destroy() {
    this.subscriptions.dispose();
    this.view.destroy();
    const pane = atom.workspace.paneForItem(this);
    if (pane) {
      pane.destroyItem(this);
    }
  }

  onDidDispose(cb: () => void) {
    this.subscriptions.add(new Disposable(cb));
  }

  getPath() {
    return this.file.getPath();
  }

  getUri() {
    return this.getURI();
  }

  // Used by atom.workspace.open to detect already open URIs
  getURI() {
    return this.getPath();
  }

  getTitle() {
    const filePath = this.getPath();
    return filePath ? path.basename(filePath) : "untitled";
  }

  updateTitle() {
    this.onDidChangeTitleCallbacks.forEach(cb => cb());
  }

  onDidChangeTitle(cb: Function) {
    this.onDidChangeTitleCallbacks.add(cb);
    return new Disposable(() => {
      this.onDidChangeTitleCallbacks.delete(cb);
    });
  }

  isEqual(other: any) {
    return other instanceof PdfEditor && this.getURI() === other.getURI();
  }

  onDidInteract(cb: (click: PdfMouseEvent) => void): Disposable {
    return this.view.events.on("click", (click: PdfMouseEvent) => {
      if (click.ctrlKey) {
        cb(click);
      }
    });
  }

  onDidClick(cb: (pos: PdfMouseEvent) => void): Disposable {
    return this.view.events.on("click", cb);
  }

  onDidDoubleClick(cb: (pos: PdfMouseEvent) => void): Disposable {
    return this.view.events.on("dblclick", cb);
  }

  scrollToPosition(pos: PdfPosition, options?: any) {
    this.view.scrollToPosition(pos, options);
  }

  setAutoReload(enabled: boolean) {
    this.autoReload = enabled;
  }

  reload(uri?: string) {
    if (uri && uri !== this.getURI()) {
      this.fileSubscriptions.dispose();
      this.fileSubscriptions = new CompositeDisposable();
      this.file = new File(uri);
      this.subscribeToFile();
    }
    this.view.update();
  }
}
