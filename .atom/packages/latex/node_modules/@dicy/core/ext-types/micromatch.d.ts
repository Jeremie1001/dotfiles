declare module "micromatch" {
  type MatchFunction = ((value: string) => boolean);

  export function matcher(pattern: string, opts?: any): MatchFunction;
}
