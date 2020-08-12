declare module "yargs-parser" {
  interface Parser {
    (args: string[], options: any): any;
  }

  const parser: Parser;

  export = parser;
}
