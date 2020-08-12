'use babel';

import { File, Directory, TextBuffer } from 'atom';
import ParseObject from './ParseObject';

const path = require('path');

const UPDATE_FREQ = {
    'High': 0,
    'Medium': 500,
    'Low': 2000,
    'On Save Only': -1
};

// DocTree: represents the document tree and all related actions relating to the abstract tree
export default class DocTree {
    constructor(updateFreqText) {
        this.setUpdateFreq(updateFreqText);
        this.docTree = [];
        this.timeout = null;
        this.rootDir = null;
    }

    // Change update frequency
    setUpdateFreq(updateFreqText) {
        this.updateFreq = UPDATE_FREQ[updateFreqText];
    }

    // Update document tree of current editor
    updateDocTree(editor) {

        // Resets docTree
        this.docTree = [];

        // Add to docTree
        let buffNow = editor.getBuffer();

        // Scan for potential root file
        var rootPath = null;
        let regEx = new RegExp(/% ?!(?:TEX|TeX) root = (.*)/);
        buffNow.backwardsScan(regEx, result => {

            rootPath = result.match[1];
            result.stop();
        });

        if (rootPath)
        {
            // Check if '.tex' exists
            let extName = path.extname(rootPath);
            if (extName === '.tex')
            {}
            else if (extName === '')
                rootPath = rootPath + '.tex';
            else
                rootPath = null;
        }
        if (rootPath)
        {
            // Convert to absolute path
            if (!path.isAbsolute(rootPath))
            {
                let parentDir = new Directory (path.dirname(buffNow.getPath()));
                rootPath = path.join(parentDir.getRealPathSync(), rootPath);
            }

            let targetFile = new File (rootPath);

            // Check file exists
            if (!targetFile.existsSync())
                rootPath = null;
        }
        // Create the buffer
        if (rootPath) {
            buffNow = TextBuffer.loadSync(rootPath);
            this.rootDir = path.dirname(rootPath);
        }
        else
            this.rootDir = path.dirname(buffNow.getPath());

        this.appendToDocTree (buffNow, null, null);

    }

    // Add to current docTree using the textBuffer provided
    // Can be recursively called (need to make sure not calling the same
    // buffer / infinite recursive loop)
    appendToDocTree (buff, prevLvl, overrideRootDir) {
        let regEx = new RegExp(/\\(include(?:from)?|input(?:from)?|(?:sub)?import|sub(?:input|include)from|part|chapter|(?:sub){0,2}section|(?:sub)?paragraph)(?:\s*(?:%.*\s*)*\*?\s*(?:%.*\s*)*{|\s*(?:%.*\s*)*\[)/, 'gm');

        // Scan text buffer for regex
        buff.scan(regEx, result => {
            let parseObj = new ParseObject(result, buff);

            // It may be a false match (eg. commented / incorrect syntax)
            if (parseObj.parse() === null)
                return;

            // Check if it is '\include' or '\input'
            if (parseObj.level < 0) {

                if (overrideRootDir != null)
                    var targetBuff = parseObj.getTargetFileBuff(overrideRootDir);
                else
                    var targetBuff = parseObj.getTargetFileBuff(this.rootDir);

                if (targetBuff === null)
                    return;

                let thisOverrideDir = null;
                if (parseObj.level === -3 || parseObj.level === -4)
                {
                    thisOverrideDir = path.dirname(targetBuff.getPath());
                }
                else if (overrideRootDir != null)
                    thisOverrideDir = overrideRootDir;

                // Store previous file information (handle start pt and path)
                this.appendToDocTree(targetBuff,
                    {
                        handleStartPt: result.range.start,
                        filePath: buff.getPath()
                    },
                    thisOverrideDir
                );
            }
            else {
                // Normal header (not '\include' or '\input')
                this.docTree.push(parseObj.createDocNode(prevLvl));
            }
        });

    }

    // Called whenever tab stops changing or when document is saved
    updateTreeView(editor, updateImmediately, treeView) {
        if (updateImmediately || this.updateFreq <= 0) {
            this.updateDocTree(editor);
            treeView.updateTree(this.docTree, editor);
        }
        else {
            if (this.timeout != null) {
                clearTimeout(this.timeout);
            }
            this.timeout = setTimeout(() => {
                this.updateDocTree(editor);
                treeView.updateTree(this.docTree, editor);
            }, this.updateFreq);
        }
    }

}
