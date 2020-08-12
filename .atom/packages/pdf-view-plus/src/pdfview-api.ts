import {Disposable} from "atom";

export interface PdfPosition {
  pageIndex: number;
  pointX: number;
  pointY: number;
  origin?: string;
}

export interface PdfPositionWithDimen extends PdfPosition {
  width: number;
  height: number;
}

export interface PdfMouseEvent {
  position: PdfPositionWithDimen;
  altKey: boolean;
  ctrlKey: boolean;
  metaKey: boolean;
  shiftKey: boolean;
  button: number;
  buttons: number;
}

export interface PdfView {
  getPath(): string;
  getUri(): string;
  onDidInteract(cb: (evt: PdfMouseEvent) => void): Disposable;
  onDidClick(cb: (evt: PdfMouseEvent) => void): Disposable;
  onDidDoubleClick(cb: (evt: PdfMouseEvent) => void): Disposable;
  scrollToPosition(pos: PdfPosition, options?: {origin: string}): void;
  setAutoReload(enabled: boolean): void;
  reload(): void;
}

export interface PdfEvents {
  observePdfViews(cb: (pdf: PdfView) => void): Disposable;
  onDidOpenPdfView(cb: (pdf: PdfView) => void): Disposable;
}
