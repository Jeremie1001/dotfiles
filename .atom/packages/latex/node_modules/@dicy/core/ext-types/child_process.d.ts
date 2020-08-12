declare module "child_process" {
  export function spawn(command: string, options?: SpawnOptions): ChildProcess;
}
