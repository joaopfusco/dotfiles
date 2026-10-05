import { expect, test } from 'claude-code/testing'
import type { On } from 'claude-code'

import { formatDuration, notifierCommands, preview } from './register'

const capture = (on: On, missing: string[] = []) => {
  const calls: (readonly string[])[] = []
  on('session.cwd', () => ({ value: '/Users/joaop/dotfiles' }))
  on('turn.complete', (_$, e) => ({ text: e.answer }))
  on('classic.Notification', () => ({}))
  on('process.run', (_$, e) => {
    calls.push(e.argv)
    const exitCode = missing.includes(e.argv[0] ?? '') ? 127 : 0
    return { value: { exitCode, stdout: '', stderr: '', isStdoutTruncated: false, isStderrTruncated: false } }
  })
  return calls
}

const osascript = (title: string, body: string) => notifierCommands(title, body, 'normal')[0]

const turn = { answer: 'Moved the mod.\nMore text', isAborted: false, turnId: 't1' }

test('formats durations', () => {
  expect(formatDuration(42_000)).toBe('42s')
  expect(formatDuration(134_000)).toBe('2m 14s')
})

test('previews the first non-empty line, cut to length', () => {
  expect(preview('\n  Moved the mod.\nrest')).toBe('Moved the mod.')
  expect(preview('x'.repeat(100))).toHaveLength(80)
})

test('passes title and body as osascript arguments, never inside the script', () => {
  const argv = osascript('a "quoted" title', 'body')
  expect(argv?.slice(-2)).toEqual(['a "quoted" title', 'body'])
})

test('notifies a long answered turn through osascript', async ($, on) => {
  const calls = capture(on)
  await $.turn.complete({ ...turn, durationMs: 134_000, reason: 'answer' })
  expect(calls).toEqual([osascript('Claude Code · dotfiles', '2m 14s — Moved the mod.')])
})

test('falls back to notify-send where osascript is missing', async ($, on) => {
  const calls = capture(on, ['osascript'])
  await $.turn.complete({ ...turn, durationMs: 90_000, reason: 'error' })
  expect(calls[1]).toEqual(['notify-send', '--app-name', 'Claude Code', '--urgency', 'critical', 'Claude Code · dotfiles', '1m 30s — turn ended with error'])
})

test('stays quiet for short, aborted and subagent turns', async ($, on) => {
  const calls = capture(on)
  await $.turn.complete({ ...turn, durationMs: 10_000, reason: 'answer' })
  await $.turn.complete({ ...turn, durationMs: 134_000, reason: 'aborted' })
  await $.turn.complete({ ...turn, durationMs: 134_000, reason: 'answer', agentId: 'a1' })
  expect(calls).toEqual([])
})

test('honours the configured threshold', { options: { thresholdSeconds: 5 } }, async ($, on) => {
  const calls = capture(on)
  await $.turn.complete({ ...turn, durationMs: 10_000, reason: 'answer' })
  expect(calls).toHaveLength(1)
})

test('notifies a permission prompt but not the idle reminder', async ($, on) => {
  const calls = capture(on)
  await $.classic.Notification({ message: 'Claude needs your permission to use Bash', notification_type: 'permission_prompt' })
  await $.classic.Notification({ message: 'Claude is waiting for your input', notification_type: 'idle_prompt' })
  expect(calls).toEqual([osascript('Claude Code · dotfiles', 'Claude needs your permission to use Bash')])
})
