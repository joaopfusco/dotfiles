export type ContextSnapshot = { tokens: number; window: number; percent: number }

export type LimitWindow = { kind: string; percentUsed: number; resetsAt?: string }

declare module 'claude-code' {
  interface PluginState {
    'usage-band': {
      context: ContextSnapshot | null
      limits: LimitWindow[]
    }
  }
}
