'use babel';

import {latexLogo} from './latex-logo';

export default class LatexTreeView {

    constructor (serializedState = {}) {

        // Create root element
        this.rootElement = document.createElement('div');
        this.rootElement.classList.add('latex-tree-view');

        // TODO: currently we do not to anything with serializedState
        // See if needed to put more information in  serializedState
        // and use it to reconstruct the tree view
        this.selectedNowInd = null;
        this.textEditorNow = null;
        this.docTree = null;
        this.foldStatus = {};

        this.focusEditorAfterClick = atom.config.get('latex-tree.focusEditorAfterClick');
        this.highlightCursorPost = atom.config.get('latex-tree.highlightWithCursorPost');
    }

    getTitle() {
        // Used by Atom for tab text
        return 'Document Tree';
    }

    getURI() {
        // Used by Atom to identify the view when toggling.
        return 'atom://latex-tree-view';
    }

    getDefaultLocation() {
        // This location will be used if the user hasn't overridden it by
        // dragging the item elsewhere. Valid values are "left", "right",
        // "bottom", and "center" (the default).
        return 'right';
    }

    getAllowedLocations() {
        // The locations into which the item can be moved.
        return ['left', 'right'];
    }

    getPreferredWidth() {
        return 300;
    }

    // Clear everything except the rootElement
    clear() {
        while (this.rootElement.hasChildNodes()) {
            this.rootElement.removeChild(this.rootElement.firstChild);
        }
    }

    // Returns an object that can be retrieved when package is activated
    serialize () {
        return {
            deserializer: 'latex-tree/LatexTreeView'
            //selectedNowInd: this.selectedNowInd,
            //textEditorNowID: this.textEditorNow.id,
            //docTree: this.docTree
        };
    }


    // Tear down any state and detach
    destroy() {
        this.clear();
        this.rootElement.remove();
    }

    getElement() {
        return this.rootElement;
    }

    // When current text editor is not LaTeX
    notAvailable() {

        this.clear();

        const naElement = document.createElement('div');
        naElement.id = "na-element";
        this.rootElement.appendChild(naElement);

        const latexLogoEl = latexLogo();
        naElement.appendChild(latexLogoEl);

        const naMessage = document.createElement('div');
        naMessage.classList.add('one-line-text');
        naMessage.textContent = "Sorry, I only understand LaTeX :(";
        naElement.appendChild(naMessage);
    }

    // Update tree view using docTree
    updateTree (docTree, editor) {

        this.clear();
        this.docTree = docTree;

        // If text editor has changed, remove selectedNowInd information
        if (editor != this.textEditorNow) {
            this.textEditorNow = editor;
            this.selectedNowInd = null;
            this.foldStatus = {};
        }

        // Create root element for tree
        const treeRoot = document.createElement('ol');
        treeRoot.id = 'tree-root';
        treeRoot.classList.add('list-tree');
        treeRoot.classList.add('has-collapsable-children');
        this.rootElement.appendChild(treeRoot);
        // Used to focus back to text editor
        treeRoot.addEventListener("mouseup", (e) => {
            if (!this.highlightCursorPost)
                this.highlight(null);
            this.focusTextEditor(e);
        });

        // Storing all latest parents of each level
        let lastParentOLNode = new Array(8);
        lastParentOLNode[0] = treeRoot;
        lastParentOLNode.fill(null, 1, 7);

        // Processing each node in docTree to turn to html element
        let haveChildren;
        let tmp = this.foldStatus;
        this.foldStatus = {};
        for (let i = 0; i < docTree.length; i++) {

            // Determine if there is a children
            if (i === docTree.length-1)
                haveChildren = false; // Last node
            else if (docTree[i+1].level <= docTree[i].level)
                haveChildren = false;
            else
                haveChildren = true;

            // Create the html element
            let nodeElement = document.createElement('li');
            let nameTag = document.createElement('div');
            let txt = document.createElement('span');
            txt.textContent = docTree[i].text;
            nameTag.appendChild(txt);
            nodeElement.appendChild(nameTag);
            docTree[i].htmlElement = nodeElement;

            // Append html element to correct parent
            for (var parentNodeLvl = docTree[i].level-1; parentNodeLvl >= 0; parentNodeLvl--) {
                if (lastParentOLNode[parentNodeLvl] != null) {
                    lastParentOLNode[parentNodeLvl].appendChild(nodeElement);
                    break;
                }
            }

            if (haveChildren) {
                docTree[i].listItemElement = nameTag;
                nodeElement.classList.add('list-nested-item');

                // Create additional elements for children of the element
                let childList = document.createElement('ol');
                childList.classList.add('list-tree');
                nodeElement.appendChild(childList);

                // Updating array of parents; removing parents with higher
                // levels than the current node
                lastParentOLNode[docTree[i].level] = childList;
                for (var j = docTree[i].level+1; j < lastParentOLNode.length; j++) {
                    lastParentOLNode[j] = null;
                }

                // Check fold status
                let foldStatusStr = this.docTree[i].level + '_' + this.docTree[i].text;
                if (foldStatusStr in tmp) {
                    if (tmp[foldStatusStr] == 1) {
                        nodeElement.classList.add('collapsed');
                        this.foldStatus[foldStatusStr] = 1;
                    }
                }

            }
            else {
                docTree[i].listItemElement = nodeElement;
            }

            // Setting correct style, id and event listeners for the listItem element
            docTree[i].listItemElement.classList.add('list-item');
            docTree[i].listItemElement.id = 'list-item-' + i;
            docTree[i].listItemElement.addEventListener("mousedown", (e) => {
                this.clicked(e);
            });

        }

        // Highlight the previously remembered item
        // Only when previously rememberd item still exists
        if (this.highlightCursorPost && this.selectedNowInd != null && this.selectedNowInd < this.docTree.length) {
            docTree[this.selectedNowInd].listItemElement.classList.add('selected-new');
        }

        // Otherwise highlight currently selected item
        this.updateHighlight(editor.getCursorBufferPosition());
    }

    // Called whenever there is a mousedown on an element
    clicked(e) {

        // Checks it is from the primary button
        if (e.button === 0) {
            nodeIndex = parseInt(e.currentTarget.id.substring(10));
            if (e.offsetX < e.currentTarget.childNodes[0].offsetLeft) {
                if (e.currentTarget.nodeName === 'DIV') {
                    let parent = e.currentTarget.parentElement;
                    let foldStatusStr = this.docTree[nodeIndex].level + '_' + this.docTree[nodeIndex].text;
                    if (parent.classList.contains('collapsed')) {
                        parent.classList.remove('collapsed');
                        this.foldStatus[foldStatusStr] = 0;
                    }
                    else {
                        parent.classList.add('collapsed');
                        this.foldStatus[foldStatusStr] = 1;
                    }
                    return;
                }
            }
            this.highlight(nodeIndex);
            let docNodeNow = this.docTree[this.selectedNowInd];
            if (docNodeNow.filePath === this.textEditorNow.getPath())
                this.textEditorNow.setCursorBufferPosition(docNodeNow.startPt);

            else {
                atom.workspace.open(docNodeNow.filePath,
                    {
                        searchAllPanes: true,
                        initialLine: docNodeNow.startPt.row,
                        initialColumn: docNodeNow.startPt.column
                    }
                ).then( () => {
                    // For some reason this is required to scroll properly
                    atom.workspace.getActiveTextEditor().scrollToBufferPosition(docNodeNow.startPt,
                    {
                        center: true
                    });
                } );
            }
        }
    }

    // Called whenever a click is finished (ie mousedown + mouseup)
    // Just focuses on the text editor so user can continue typing right away
    focusTextEditor(e) {
        if (this.focusEditorAfterClick && e.button === 0) {
            atom.workspace.paneForItem(this.textEditorNow).activate();
        }
    }

    // Update highlight to current cursor position
    updateHighlightToCurrent () {
        if (this.textEditorNow === null)
            return;
        this.updateHighlight(this.textEditorNow.getCursorBufferPosition());
    }

    // Update highlight when the cursor position changed
    updateHighlight(cursorPosition) {

        // Get current file path
        let pathNow = this.textEditorNow.getPath();

        // If config option disabled
        if (!this.highlightCursorPost)
            return;

        // If called before first docTree generated / zero length docTree
        if (this.docTree === null || this.docTree.length === 0)
            return;

        // Find closest title for current file path
        let ind;
        let lastInd = null;
        for (ind = 0; ind < this.docTree.length; ind++) {
            let nodeNow = this.docTree[ind];

            // Current file's direct node
            if (nodeNow.filePath === pathNow)
            {
                if (nodeNow.startPt.isGreaterThan(cursorPosition))
                    break;

                lastInd = ind;
            }

            // Check previous level
            else if (nodeNow.prevLvl != null && nodeNow.prevLvl.filePath === pathNow)
            {
                if (nodeNow.prevLvl.handleStartPt.isGreaterThan(cursorPosition))
                    break;

                if (lastInd === null || this.docTree[lastInd].prevLvl != nodeNow.prevLvl)
                    lastInd = ind;
            }

        }

        // Default to be in front of all nodes (nothing highlited, scroll to top)
        if (lastInd === null)
        {
            this.highlight(null);
            this.scrollTo(0);
        }
        else
        {
            this.highlight(lastInd);
            this.scrollTo(lastInd);
        }
    }

    // Remove original highlight and highlight the element docTree[newInd]
    // To remove all highlighting without adding new highlighting, just
    // use null as argument for newInd
    highlight(newInd) {

        // Remove previously selected item and update selectedNowInd
        if (this.selectedNowInd != null && this.selectedNowInd < this.docTree.length) {
            this.docTree[this.selectedNowInd].listItemElement.classList.remove('selected-new');
        }
        this.selectedNowInd = newInd;

        // Add relevant style to the current selected item
        if (this.selectedNowInd != null)
            this.docTree[this.selectedNowInd].listItemElement.classList.add('selected-new');
    }

    // Scroll to docTree[ind]
    scrollTo (ind) {
        this.docTree[ind].htmlElement.scrollIntoViewIfNeeded();
    }
}
