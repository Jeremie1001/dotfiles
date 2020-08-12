import {Disposable, CompositeDisposable} from "atom";
import * as path from "path";
import {PdfEditor} from "./pdf-editor";
import {SynctexConsumer} from "./pfdview-consumer-synctex";
import {PdfEvents} from "./pdfview-api";

class PdfViewPackage {
  subscriptions: CompositeDisposable;
  pdfExtensions: Set<string>;

  editors: Set<PdfEditor>;
  openSubscriptions: Set<(pdf: PdfEditor) => void>;

  synctexConsumer?: SynctexConsumer;

  constructor() {
    this.subscriptions = new CompositeDisposable();
    this.pdfExtensions = new Set();
    this.openSubscriptions = new Set();
    this.editors = new Set();
  }

  activate() {
    this.subscriptions.add(
      atom.workspace.addOpener(uri => {
        const uriExtension = path.extname(uri).toLowerCase();
        if (this.pdfExtensions.has(uriExtension)) {
          const editor = new PdfEditor(uri);
          this.subscribeToEditor(editor);
          return editor;
        }
      }),
      atom.config.observe("pdf-view-plus.fileExtensions", this.updateFileExtensions.bind(this)),
      atom.config.observe("pdf-view-plus.enableSynctex", this.toggleSynctex.bind(this))
    );
  }

  deserialize(params: any) {
    const pdfEditor = PdfEditor.deserialize(params);
    if (pdfEditor) {
      this.subscribeToEditor(pdfEditor);
    }
    return pdfEditor;
  }

  subscribeToEditor(editor: PdfEditor) {
    this.editors.add(editor);
    editor.onDidDispose(() => {
      this.editors.delete(editor);
    });
    this.openSubscriptions.forEach(cb => {
      cb(editor);
    });
  }

  dispose() {
    this.subscriptions.dispose();
  }

  deactivate() {
    this.dispose();
  }

  updateFileExtensions(extensions: string[]) {
    this.pdfExtensions.clear();
    for (let extension of extensions) {
      extension = extension.toLowerCase().replace(/^\.*/, ".");
      this.pdfExtensions.add(extension);
    }
  }

  toggleSynctex(enabled: boolean) {
    if (enabled) {
      if (!this.synctexConsumer) {
        this.synctexConsumer = new SynctexConsumer();
        this.synctexConsumer.consumePdfview(this.providePdfEvents());
      }
    } else if (this.synctexConsumer) {
      atom.notifications.addInfo("Restart to disable SyncTeX");
    }
  }

  providePdfEvents(): PdfEvents {
    return {
      observePdfViews: cb => {
        this.editors.forEach(editor => {
          cb(editor);
        });
        this.openSubscriptions.add(cb);
        return new Disposable(() => {
          this.openSubscriptions.delete(cb);
        });
      },
      onDidOpenPdfView: cb => {
        this.openSubscriptions.add(cb);
        return new Disposable(() => {
          this.openSubscriptions.delete(cb);
        });
      },
    };
  }
}

const pack = new PdfViewPackage();

module.exports = pack;
