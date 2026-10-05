import type { EngineInterface, Register } from 'claude-code'

const PREVIEW_LENGTH = 80

export const formatDuration = (ms: number): string => {
  const seconds = Math.round(ms / 1000)
  if (seconds < 60) return `${seconds}s`
  return `${Math.floor(seconds / 60)}m ${seconds % 60}s`
}

export const preview = (answer: string): string => {
  const line = answer.split('\n').find(l => l.trim() !== '')?.trim() ?? ''
  return line.length > PREVIEW_LENGTH ? `${line.slice(0, PREVIEW_LENGTH - 1)}…` : line
}

const projectName = async ($: EngineInterface): Promise<string> => {
  const cwd = await $.session.cwd()
  return cwd.split('/').filter(Boolean).pop() ?? cwd
}

type Urgency = 'normal' | 'critical'

const KITTY_BUNDLE_ID = 'net.kovidgoyal.kitty'

export const notifierCommands = (title: string, body: string, urgency: Urgency): string[][] => [
  ['terminal-notifier', '-title', title, '-message', body, '-activate', KITTY_BUNDLE_ID, '-group', title],
  ['osascript', '-e', 'on run argv', '-e', 'display notification (item 2 of argv) with title (item 1 of argv)', '-e', 'end run', title, body],
  ['notify-send', '--app-name', 'Claude Code', '--urgency', urgency, title, body],
]

const tryRun = async ($: EngineInterface, argv: string[]): Promise<boolean> => {
  try {
    const { exitCode } = await $.process.run(argv, { timeoutMs: 5000 })
    return exitCode === 0
  } catch {
    return false
  }
}

const notify = async ($: EngineInterface, title: string, body: string, urgency: Urgency) => {
  for (const argv of notifierCommands(title, body, urgency)) {
    if (await tryRun($, argv)) return
  }
  $.ui.toast(`${title}: ${body}`)
}

export const register: Register = (on, options) => {
  const thresholdMs = Number(options.thresholdSeconds ?? 60) * 1000

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    if (e.agentId || e.reason === 'aborted' || e.durationMs < thresholdMs) return result

    const title = `Claude Code · ${await projectName($)}`
    const duration = formatDuration(e.durationMs)
    if (e.reason === 'answer') {
      await notify($, title, `${duration} — ${preview(e.answer) || 'done'}`, 'normal')
    } else {
      await notify($, title, `${duration} — turn ended with ${e.reason}`, 'critical')
    }
    return result
  })

  // idle_prompt fires after the turn already notified
  on('classic.Notification', async ($, e, next) => {
    const result = await next(e)
    if (e.notification_type === 'idle_prompt') return result

    await notify($, e.title ?? `Claude Code · ${await projectName($)}`, e.message, 'critical')
    return result
  })
}
