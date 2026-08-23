import { useCallback, useEffect, useState } from 'react'
import { TrackerDevice, type TrackerLabels } from './components/TrackerDevice'
import { useCefTransparency } from './hooks/useCefTransparency'
import { useNuiEvent } from './hooks/useNuiEvent'
import { fetchNui } from './utils/fetchNui'
import { isEnvBrowser } from './utils/misc'

type TrackerStatePayload = {
  action?: string
  labels?: Partial<TrackerLabels>
  cooldown?: number
}

const fallbackLabels: TrackerLabels = {
  status: 'STATUS',
  gps: 'GPS',
  ping: 'Track',
  number: 'Phone number',
  empty: 'Enter a number',
  miss: 'Unable to locate phone.',
  cooldown: 'Wait {{time}}s',
  noItem: 'Tracker required',
}

export default function App() {
  useCefTransparency()
  const [open, setOpen] = useState(isEnvBrowser())
  const [labels, setLabels] = useState<TrackerLabels>(fallbackLabels)
  const [cooldownSeconds, setCooldownSeconds] = useState(10)

  const closeDevice = useCallback(() => {
    setOpen(false)
    void fetchNui('TRACKER_CLOSE', {}, { ok: true })
  }, [])

  useNuiEvent<TrackerStatePayload>('TRACKER_STATE', (payload) => {
    if (payload?.action === 'OPEN') {
      setLabels({ ...fallbackLabels, ...payload.labels })
      if (typeof payload.cooldown === 'number' && payload.cooldown >= 0) {
        setCooldownSeconds(payload.cooldown)
      }
      setOpen(true)
      return
    }
    if (payload?.action === 'CLOSE') setOpen(false)
  })

  useEffect(() => {
    if (!open) return
    const onKey = (event: KeyboardEvent) => {
      if (event.key !== 'Escape') return
      event.preventDefault()
      closeDevice()
    }
    window.addEventListener('keydown', onKey)
    return () => window.removeEventListener('keydown', onKey)
  }, [closeDevice, open])

  if (!open) return null

  return (
    <TrackerDevice labels={labels} cooldownSeconds={cooldownSeconds} onClose={closeDevice} />
  )
}
