// Edits the repo to make a source consistent with how apm install will work.
// The package.json changes are reverted in postversion, which is before
// apx starts making the bundle.

const {spawnSync, shrinkwrap, uploadGit} = require("./utils");
const fs = require("fs");
const path = require("path");

function lint(fix = true) {
  console.log("Fixing lint issues...");
  spawnSync("npm", ["run", fix ? "fix-lint" : "lint"]);
}

function recompileSource() {
  console.log("Recompiling source...");
  spawnSync("rm", ["-rf", "./dist"]);
  spawnSync("tsc", [
    "--declarationMap",
    "false",
    "--inlineSourceMap",
    "false",
    "--inlineSources",
    "false",
  ]);
}

function alterPackageJson() {
  console.log("Altering package.json...");
  const pj = require("../package.json");
  fs.renameSync(
    path.resolve(__dirname, "../package.json"),
    path.resolve(__dirname, "../package.original.json")
  );
  if (!pj.dependencies) {
    pj.dependencies = {};
  }
  pj.dependencies["atom-ts-transpiler"] = "1.5.2";
  pj.dependencies["typescript"] = pj.devDependencies["typescript"];

  pj.atomTranspilers = [
    {
      transpiler: "atom-ts-transpiler",
      glob: "{!(node_modules)/**/,}*.ts?(x)",
      options: {
        verbose: true,
      },
    },
  ];

  pj.main = "./src/main.ts";
  fs.writeFileSync(path.resolve(__dirname, "../package.json"), JSON.stringify(pj, null, 2));
}

function runtests() {
  // TODO
  console.log("Running tests...");
  return;
}

function main() {
  lint();
  recompileSource();
  runtests();
  alterPackageJson();
  shrinkwrap();
  uploadGit("Convert to apm compatible release state");
}

main();
