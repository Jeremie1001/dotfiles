'use babel';

import { Point, Range } from 'atom';
import LatexTreeView from './latex-tree-view';
import { CompositeDisposable, Disposable } from 'atom';
import DocTree from './DocTree';

export default {

    // Global subscriptions (eg tab switches)
    globalSubscriptions: null,
    // Current editor subscriptions (cleared when current editor changes,
    // eg when user changes / closes tab)
    currentSubscriptions: null,
    // Subscription for updating tree view on the go (not only on save)
    updateSubscription: null,
    // Subscription used for deserializing
    deserializeSubscriptions: null,
    // Document tree object
    docTree: null,
    // Tree view object
    treeView: null,
    // Remembers last latex editor to improve performance
    lastLatexPane: null,

    activate () {

        // If activate is called because of deserialization, dispose
        // the relevant subscriptions (since deserialize would only
        // be called once)
        if (this.deserializeSubscriptions != null)
            this.deserializeSubscriptions.dispose();

        this.treeView = new LatexTreeView();

        // Create document tree and read relevant settings
        this.docTree = new DocTree(atom.config.get('latex-tree.updateFreq'));

        // Events subscribed to in atom's system can be easily cleaned up with
        // a CompositeDisposable
        this.globalSubscriptions = new CompositeDisposable();
        this.currentSubscriptions = new CompositeDisposable();

        // Register command that toggles this view
        this.globalSubscriptions.add(
            atom.commands.add(
                'atom-workspace', { 'latex-tree:toggle-tree-view': () => {
                    atom.workspace.toggle('atom://latex-tree-view');
                }}
            )
        );

        // When tab stops changing, update current editor settings
        this.globalSubscriptions.add(
            atom.workspace.onDidStopChangingActivePaneItem(paneItem => {
                this.updateCurrentSettings(paneItem);
            })
        );

        // Open panel for toggle commands
        this.globalSubscriptions.add(atom.workspace.addOpener(uri => {
            if (uri === 'atom://latex-tree-view') {
                return this.treeView;
            }
        }));

        // Change behavior with config changes
        this.globalSubscriptions.add(
            atom.config.onDidChange('latex-tree.updateFreq', (e) => {
                this.docTree.setUpdateFreq(e.newValue);
                if (this.docTree.updateFreq === -1) {
                    if (this.updateSubscription != null)
                        this.updateSubscription.dispose();
                }
                else if (e.oldValue === "On Save Only") {
                    this.subscribeStopChanging();
                }
            }),
            atom.config.onDidChange('latex-tree.focusEditorAfterClick', (e) => {
                this.treeView.focusEditorAfterClick = e.newValue;
            }),
            atom.config.onDidChange('latex-tree.highlightWithCursorPost', (e) => {
                this.treeView.highlightCursorPost = e.newValue;
                if (this.treeView.highlightCursorPost) {
                    // Highlight for current document
                    if (this.isLatex(atom.workspace.getActiveTextEditor()))
                        this.treeView.updateHighlightToCurrent();
                }
                else {
                    this.treeView.highlight(null);
                }
            })
        );

        // Destroy tree views when the package is deactivated
        new Disposable(() => {
            atom.workspace.getPaneItems().forEach(item => {
                if (item instanceof LatexTreeView)
                    item.destroy();
            });
        })

        // Update current editor settings for the first time
        this.updateCurrentSettings(atom.workspace.getActiveTextEditor());
    },

    // Called whenever the current tab stops changing
    updateCurrentSettings(paneItem) {

        // Check it is a text editor
        if (!atom.workspace.isTextEditor(paneItem))
            return;

        // Checks if language is LaTeX
        if (this.isLatex(paneItem)) {

            // Remove previous subscriptions
            this.currentSubscriptions.dispose();

            // Subscribe to save events
            this.currentSubscriptions.add(
                paneItem.onDidSave( () => {
                    this.docTree.updateTreeView(paneItem, true, this.treeView);
                })
            );

            // Subscribe to stop changing events
            if (this.docTree.updateFreq != -1) {
                this.subscribeStopChanging();
            }

            // Subscribe to cursor change events
            this.currentSubscriptions.add(
                paneItem.onDidChangeCursorPosition( (e) => {
                    this.treeView.updateHighlight(e.newBufferPosition);
                })
            );

            // Update tree view for the first time
            // only if the pane item has changed
            // ie it is not the same as the lastLatexPane
            if (paneItem != this.lastLatexPane) {
                this.lastLatexPane = paneItem;
                this.docTree.updateTreeView(paneItem, true, this.treeView);
            }
            else {
                // Still update highlight even if the pane item did not change
                this.treeView.updateHighlightToCurrent();
            }
        }
        else {
            // Language is not LaTeX
            this.lastLatexPane = null;
            this.treeView.notAvailable();
            this.currentSubscriptions.dispose();
        }
    },

    deactivate() {
        this.globalSubscriptions.dispose();
        this.currentSubscriptions.dispose();
        this.deserializeSubscriptions.dispose();
        this.treeView.destroy();
    },

    // Function will be called when Atom starts if there is
    // deserialization to do, since it is registered in package.json
    // Do not do anything right away because everything (including
    // the atom environment) has not been loaded yet, instead
    // wait until everything finished loading then toggle (open)
    // the tree view
    deserializeTreeView (serialized) {
        this.deserializeSubscriptions = atom.packages.onDidActivateInitialPackages(() => {
            atom.commands.dispatch(document.querySelector("atom-workspace"), "latex-tree:toggle-tree-view");
        })
    },

    // Subscribe to stop changing events
    subscribeStopChanging () {
        let paneItem = atom.workspace.getActiveTextEditor();
        if (!paneItem)
            return;
        if (this.updateSubscription != null)
            this.updateSubscription.dispose();
        this.updateSubscription = paneItem.onDidStopChanging( () => {
            this.docTree.updateTreeView(paneItem, false, this.treeView);
        });
    },

    // Check if current pane is LaTeX
    isLatex (paneItem) {
        if (!paneItem)
            return false;
        return (paneItem.getRootScopeDescriptor().getScopesArray()[0]
            === 'text.tex.latex');
    }

};
