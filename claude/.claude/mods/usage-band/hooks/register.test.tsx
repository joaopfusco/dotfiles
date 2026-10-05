import { expect, mock, test } from 'claude-code/testing'
import type { SessionUsage } from 'claude-code'

import { filledCells, formatResetIn, formatTokens } from './register'

const NOW = Date.parse('2026-10-05T12:00:00Z')

const usage: SessionUsage = {
  startedAt: 0,
  context: { tokens: 212_000, window: 1_000_000, percent: 21 },
  rateLimits: [
    { kind: 'five_hour', percentUsed: 34, resetsAt: '2026-10-05T14:13:00Z' },
    { kind: 'seven_day', percentUsed: 12.5, resetsAt: '2026-10-08T16:00:00Z' },
  ],
}

const bandProps = {
  hasSurvey: false,
  isWorking: false,
  maxRows: 20,
  bodyColumns: 80,
  scroll: { offset: 0, bodyRows: 19 },
  view: {},
}

test('formats token counts like /context', () => {
  expect(formatTokens(950)).toBe('950')
  expect(formatTokens(3400)).toBe('3.4k')
  expect(formatTokens(212_000)).toBe('212k')
  expect(formatTokens(1_000_000)).toBe('1M')
})

test('formats reset times relative to now', () => {
  expect(formatResetIn('2026-10-05T14:13:00Z', NOW)).toBe('resets in 2h 13m')
  expect(formatResetIn('2026-10-08T16:00:00Z', NOW)).toBe('resets in 3d 4h')
  expect(formatResetIn('2026-10-05T12:05:00Z', NOW)).toBe('resets in 5m')
  expect(formatResetIn(undefined, NOW)).toBe('')
})

test('fills bar cells by percent, clamped to the width', () => {
  expect(filledCells(21, 40)).toBe(8)
  expect(filledCells(0, 40)).toBe(0)
  expect(filledCells(130, 40)).toBe(40)
})

test('draws nothing before the first turn', async ($, on) => {
  on('ui.render', ($, e) => {
    const { Box } = $.ui.resolve(e)
    return <Box />
  })

  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ plugin: 'usage-band', surface, component: 'AbovePrompt', props: bandProps })
    expect(await ui.find({ text: 'context' })).toBeUndefined()
    await ui.unmount()
  }
})

test('draws context, 5h and week bars after a turn completes', async ($, on) => {
  mock.clock(on, { now: NOW })
  on('session.usage', () => ({ value: usage }))
  on('turn.complete', (_$, e) => ({ text: e.answer }))

  await $.turn.complete({ answer: 'ok', durationMs: 1, isAborted: false, turnId: 't1', reason: 'answer' })

  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ plugin: 'usage-band', surface, component: 'AbovePrompt', props: bandProps })
    expect(await ui.find({ text: /context.*21%.*212k \/ 1M/ })).toBeDefined()
    expect(await ui.find({ text: /5h.*34%.*resets in 2h 13m/ })).toBeDefined()
    expect(await ui.find({ text: /week.*13%.*resets in 3d 4h/ })).toBeDefined()
    await ui.unmount()
  }
})
