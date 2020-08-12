// git push --follow-tags &&

const {spawnSync, shrinkwrap, uploadGit} = require("./utils");

const fs = require("fs");
const path = require("path");

function uploadGitTag() {
  console.log("Committing git tag...");
  spawnSync("git", ["push", "--follow-tags"]);
}

function revertPackageJson() {
  console.log("Reverting package.json...");
  const pj = require("../package.json");
  const pjo = require("../package.original.json");
  pjo.version = pj.version;
  fs.writeFileSync(path.resolve(__dirname, "../package.json"), JSON.stringify(pjo, null, 2) + "\n");
  fs.unlinkSync(path.resolve(__dirname, "../package.original.json"));
}

function main() {
  uploadGitTag();
  revertPackageJson();
  shrinkwrap();
  uploadGit("Revert to dev state");
}

main();
