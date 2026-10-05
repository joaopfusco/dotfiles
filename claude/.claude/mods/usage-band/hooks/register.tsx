import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { ContextSnapshot, LimitWindow } from '../types'

const context = atom({ plugin: 'usage-band', key: 'context' } as const, null)
const limits = atom({ plugin: 'usage-band', key: 'limits' } as const, [])

const TOKYO_NIGHT = {
  blue: '#7aa2f7',
  magenta: '#bb9af7',
  red: '#f7768e',
  fg: '#a9b1d6',
  track: '#414868',
}

const LIMIT_STYLE: Record<string, { label: string; color: string }> = {
  five_hour: { label: '5h', color: TOKYO_NIGHT.blue },
  seven_day: { label: 'week', color: TOKYO_NIGHT.magenta },
}

const LABEL_WIDTH = 8
const META_WIDTH = 24

export const formatTokens = (tokens: number): string => {
  if (tokens >= 1_000_000) return `${+(tokens / 1_000_000).toFixed(1)}M`
  if (tokens >= 10_000) return `${Math.round(tokens / 1000)}k`
  if (tokens >= 1000) return `${+(tokens / 1000).toFixed(1)}k`
  return `${tokens}`
}

export const formatResetIn = (resetsAt: string | undefined, now: number): string => {
  if (!resetsAt) return ''
  const minutes = Math.max(0, Math.round((Date.parse(resetsAt) - now) / 60_000))
  const days = Math.floor(minutes / 1440)
  const hours = Math.floor((minutes % 1440) / 60)
  if (days > 0) return `resets in ${days}d ${hours}h`
  if (hours > 0) return `resets in ${hours}h ${minutes % 60}m`
  return `resets in ${minutes}m`
}

export const filledCells = (percent: number, width: number): number =>
  Math.min(width, Math.max(0, Math.round((percent / 100) * width)))

const refresh = async ($: EngineInterface): Promise<void> => {
  const usage = await $.session.usage()
  const windows: LimitWindow[] = usage.rateLimits.map(({ kind, percentUsed, resetsAt }) => ({ kind, percentUsed, resetsAt }))
  await update($, limits, () => windows)

  const { tokens, window, percent } = usage.context
  if (tokens === undefined || percent === undefined) return
  const snapshot: ContextSnapshot = { tokens, window, percent }
  await update($, context, () => snapshot)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const result = await next(e)
    await refresh($)
    return result
  })

  on('turn.complete', async ($, e, next) => {
    const result = await next(e)
    await refresh($)
    return result
  })

  on('session.compact', async ($, e, next) => {
    const result = await next(e)
    await refresh($)
    return result
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    if (e.props.hasSurvey || e.props.view.agentId) return next(e)

    const snapshot = await read($, context)
    const windows = await read($, limits)
    if (snapshot === null && windows.length === 0) return next(e)

    const { Box, Text } = $.ui.resolve(e)
    const now = await $.clock.now()
    const barWidth = Math.max(10, e.props.bodyColumns - LABEL_WIDTH - META_WIDTH - 6)

    const row = (key: string, label: string, color: string, percent: number, meta: string) => {
      const filled = filledCells(percent, barWidth)
      const isHigh = percent >= 80
      return (
        <Text key={key}>
          <Text color={TOKYO_NIGHT.fg}>{label.padEnd(LABEL_WIDTH)}</Text>
          <Text color={isHigh ? TOKYO_NIGHT.red : color}>{'▆'.repeat(filled)}</Text>
          <Text color={TOKYO_NIGHT.track}>{'▆'.repeat(barWidth - filled)}</Text>
          <Text bold color={isHigh ? TOKYO_NIGHT.red : color}>{` ${Math.round(percent)}%`.padStart(5)}</Text>
          <Text dimColor>{`  ${meta}`}</Text>
        </Text>
      )
    }

    return (
      <Box flexDirection="column" borderStyle="round" borderColor={TOKYO_NIGHT.track} paddingX={1}>
        {snapshot
          ? row('context', 'context', 'claude', snapshot.percent, `${formatTokens(snapshot.tokens)} / ${formatTokens(snapshot.window)}`)
          : null}
        {windows.map(w => {
          const style = LIMIT_STYLE[w.kind] ?? { label: w.kind, color: TOKYO_NIGHT.blue }
          return row(w.kind, style.label, style.color, w.percentUsed, formatResetIn(w.resetsAt, now))
        })}
      </Box>
    )
  })
}
