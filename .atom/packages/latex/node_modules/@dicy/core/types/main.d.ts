/// <reference types="node" />
import { EventEmitter } from 'events';
import {
  BuilderInterface, BuilderCacheInterface, Command, Message, OptionsSource, Uri
} from '@dicy/types';

export * from '@dicy/types';

export class DiCy extends EventEmitter implements BuilderCacheInterface {
  get (file: Uri): Promise<BuilderInterface>
  clear (file: Uri): Promise<void>
  clearAll (): Promise<void>
  destroy (): Promise<void>

  getTargets (file: Uri): Promise<string[]>

  kill (file: Uri, message?: string): Promise<void>
  killAll (message?: string): Promise<void>
  run (file: Uri, commands: Command[]): Promise<boolean>

  setInstanceOptions (file: Uri, options: OptionsSource, merge?: boolean): Promise<void>
  setUserOptions (file: Uri, options: OptionsSource, merge?: boolean): Promise<void>
  setDirectoryOptions (file: Uri, options: OptionsSource, merge?: boolean): Promise<void>
  setProjectOptions (file: Uri, options: OptionsSource, merge?: boolean): Promise<void>

  on (event: 'log', listener: (file: Uri, messages: Message[]) => void): this
  on (event: string | symbol, listener: (...args: any[]) => void): this

  once (event: 'log', listener: (file: Uri, messages: Message[]) => void): this
  once (event: string | symbol, listener: (...args: any[]) => void): this

  prependListener (event: 'log', listener: (file: Uri, messages: Message[]) => void): this
  prependListener (event: string | symbol, listener: (...args: any[]) => void): this

  prependOnceListener (event: 'log', listener: (file: Uri, messages: Message[]) => void): this
  prependOnceListener (event: string | symbol, listener: (...args: any[]) => void): this

  removeListener (event: 'log', listener: (file: Uri, messages: Message[]) => void): this
  removeListener (event: string | symbol, listener: (...args: any[]) => void): this
}
