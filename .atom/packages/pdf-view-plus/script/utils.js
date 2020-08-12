const cp = require("child_process");

function spawnSync(cmd, args) {
  return cp.spawnSync(cmd, args, {stdio: "inherit"});
}

function shrinkwrap() {
  console.log("Making shrinkwrap...");
  spawnSync("npm", ["shrinkwrap"]);
}

function uploadGit(msg) {
  console.log("Committing all changes...");
  spawnSync("git", ["add", "."]);
  spawnSync("git", ["commit", "-m", msg || "prepare for publish"]);
  spawnSync("git", ["push"]);
}

module.exports = {spawnSync, shrinkwrap, uploadGit};
