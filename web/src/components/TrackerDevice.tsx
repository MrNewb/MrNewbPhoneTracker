import { useCallback, useEffect, useId, useRef, useState, type CSSProperties, type FormEvent, type KeyboardEvent, type MouseEvent } from 'react'
import deviceUrl from '../assets/tracker-device.webp'
import { DEVICE_ASPECT, barRegion, closeRegion, keyRegions, screenRegion, type Region } from './deviceRegions'
import { fetchNui } from '../utils/fetchNui'
import styles from './TrackerDevice.module.css'

export type TrackerLabels = {
  status: string
  gps: string
  ping: string
  number: string
  empty: string
  miss: string
  cooldown: string
  noItem: string
  ready: string
  searching: string
  locked: string
  hint: string
  close: string
  backspace: string
  clear: string
}

const barPlate: Region = { x: barRegion.x + 0.014, y: barRegion.y + 0.007, w: barRegion.w - 0.028, h: barRegion.h - 0.014 }

function region(r: Region): CSSProperties {
  return { left: `${r.x * 100}%`, top: `${r.y * 100}%`, width: `${r.w * 100}%`, height: `${r.h * 100}%` }
}

type KeyAction = { kind: 'digit'; value: string } | { kind: 'backspace' } | { kind: 'clear' }

const keypadLayout: KeyAction[] = [
  ...['1', '2', '3', '4', '5', '6', '7', '8', '9'].map((value) => ({ kind: 'digit', value }) as KeyAction),
  { kind: 'backspace' },
  { kind: 'digit', value: '0' },
  { kind: 'clear' },
]

const PHONE_NUMBER_MAX_LENGTH = 10
// 3-3-4: a wider gap after the third and sixth digit keeps the number scannable
const GROUP_AFTER = [2, 5]
const MIN_SEARCH_MS = 400
const LOCKED_HOLD_MS = 1100

// Module-level so closing the device does not reset the cooldown.
let submitCooldownUntilMs = 0

function sanitizePhoneNumber(value: string) {
  return value.replace(/\D/g, '').slice(0, PHONE_NUMBER_MAX_LENGTH)
}

function formatTime(template: string, seconds: number) {
  return template.replace(/\{\{\s*time\s*\}\}/g, String(seconds))
}

function getCooldownRemainingSeconds() {
  return Math.max(0, Math.ceil((submitCooldownUntilMs - Date.now()) / 1000))
}

function armSubmitCooldown(seconds: number) {
  const wait = Math.max(0, Math.ceil(seconds))
  if (wait <= 0) return
  submitCooldownUntilMs = Math.max(submitCooldownUntilMs, Date.now() + wait * 1000)
}

function pause(ms: number) {
  return new Promise<void>((resolve) => window.setTimeout(resolve, ms))
}

type PingResult = { ok: boolean; reason?: string; wait?: number }
type Failure = '' | 'empty' | 'noitem' | 'miss' | 'cooldown'
type Phase = 'idle' | 'pinging' | 'locked'
type Tone = 'hint' | 'ready' | 'busy' | 'wait' | 'miss' | 'locked'

function BackspaceIcon() {
  return (
    <svg className={styles.keyIcon} viewBox="0 0 24 24" aria-hidden>
      <path d="M9 5H20V19H9L3 12Z" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinejoin="round" />
      <path d="M12.5 9.5L16.5 14.5M16.5 9.5L12.5 14.5" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" />
    </svg>
  )
}

function CloseIcon() {
  return (
    <svg className={styles.closeIcon} viewBox="0 0 24 24" aria-hidden>
      <path d="M6 6L18 18M18 6L6 18" stroke="currentColor" strokeWidth="2" strokeLinecap="round" />
    </svg>
  )
}

function NumberReadout({ value }: { value: string }) {
  const slots = Array.from({ length: PHONE_NUMBER_MAX_LENGTH }, (_, index) => value[index])
  return (
    <div className={styles.number} aria-hidden>
      {slots.map((digit, index) => (
        <span
          key={index}
          className={`${styles.digit} ${digit === undefined ? styles.ghost : ''} ${GROUP_AFTER.includes(index) ? styles.grouped : ''}`}
        >
          {digit ?? '·'}
        </span>
      ))}
    </div>
  )
}

export function TrackerDevice({
  labels,
  cooldownSeconds,
  onClose,
}: {
  labels: TrackerLabels
  cooldownSeconds: number
  onClose: () => void
}) {
  const inputRef = useRef<HTMLInputElement>(null)
  const statusId = useId()
  const [phoneNumber, setPhoneNumber] = useState('')
  const [phase, setPhase] = useState<Phase>('idle')
  const [failure, setFailure] = useState<Failure>('')
  const [missCount, setMissCount] = useState(0)
  const [cooldownLeft, setCooldownLeft] = useState(() => getCooldownRemainingSeconds())

  const refreshCooldown = useCallback(() => {
    const remaining = getCooldownRemainingSeconds()
    setCooldownLeft(remaining)
    return remaining
  }, [])

  useEffect(() => {
    inputRef.current?.focus()
  }, [])

  useEffect(() => {
    refreshCooldown()
    const timer = window.setInterval(() => {
      const remaining = refreshCooldown()
      if (remaining <= 0) window.clearInterval(timer)
    }, 250)
    return () => window.clearInterval(timer)
  }, [refreshCooldown, phase])

  const busy = phase !== 'idle'
  const submitLocked = busy || cooldownLeft > 0

  function editNumber(next: (current: string) => string) {
    if (phase !== 'idle') return
    setFailure('')
    setPhoneNumber((current) => sanitizePhoneNumber(next(current)))
    inputRef.current?.focus()
  }

  function handleKey(action: KeyAction) {
    if (action.kind === 'digit') editNumber((current) => current + action.value)
    else if (action.kind === 'backspace') editNumber((current) => current.slice(0, -1))
    else editNumber(() => '')
  }

  async function pingNumber() {
    if (submitLocked) return

    const digits = sanitizePhoneNumber(phoneNumber)
    if (!digits) {
      setFailure('empty')
      setMissCount((count) => count + 1)
      return
    }

    setPhase('pinging')
    setFailure('')
    let result: PingResult = { ok: false, reason: 'miss' }
    try {
      const [response] = await Promise.all([
        fetchNui<PingResult>(
          'TRACKER_PING',
          { phoneNumber: digits },
          digits === '5550147' ? { ok: true, wait: cooldownSeconds } : { ok: false, reason: 'miss', wait: cooldownSeconds },
        ),
        pause(MIN_SEARCH_MS),
      ])
      result = response
    } catch {
      result = { ok: false, reason: 'miss' }
    }

    const waitSeconds = typeof result.wait === 'number' ? result.wait : cooldownSeconds
    if (result.ok || result.reason === 'miss' || result.reason === 'cooldown') {
      armSubmitCooldown(waitSeconds)
      refreshCooldown()
    }

    if (result.ok) {
      setPhase('locked')
      await pause(LOCKED_HOLD_MS)
      onClose()
      return
    }

    if (result.reason === 'empty') setFailure('empty')
    else if (result.reason === 'noitem') setFailure('noitem')
    else if (result.reason === 'cooldown') setFailure('cooldown')
    else setFailure('miss')
    setMissCount((count) => count + 1)
    setPhase('idle')
    inputRef.current?.focus()
  }

  function onSubmit(event: FormEvent) {
    event.preventDefault()
    void pingNumber()
  }

  function onKeyDown(event: KeyboardEvent<HTMLInputElement>) {
    if (event.key === 'Enter') {
      event.preventDefault()
      void pingNumber()
      return
    }
    if (event.key.length === 1 && !/\d/.test(event.key) && !event.ctrlKey && !event.metaKey) {
      event.preventDefault()
    }
  }

  function onStageClick(event: MouseEvent<HTMLDivElement>) {
    if (event.target === event.currentTarget && phase !== 'locked') onClose()
  }

  let tone: Tone = 'hint'
  let statusText = labels.hint
  if (phase === 'locked') {
    tone = 'locked'
    statusText = labels.locked
  } else if (phase === 'pinging') {
    tone = 'busy'
    statusText = labels.searching
  } else if (failure === 'noitem') {
    tone = 'miss'
    statusText = labels.noItem
  } else if (failure === 'empty') {
    tone = 'miss'
    statusText = labels.empty
  } else if (failure === 'miss') {
    tone = 'miss'
    statusText = labels.miss
  } else if (phoneNumber.length > 0 && cooldownLeft === 0) {
    tone = 'ready'
    statusText = labels.ready
  }

  let trackText = labels.ping
  if (phase === 'locked') trackText = labels.locked
  else if (phase === 'pinging') trackText = labels.searching
  else if (cooldownLeft > 0) trackText = formatTime(labels.cooldown, cooldownLeft)

  const screenStyle = region(screenRegion)

  return (
    <div className={styles.stage} onClick={onStageClick}>
      <form className={styles.shell} onSubmit={onSubmit}>
        <img className={styles.body} src={deviceUrl} alt="" draggable={false} />
        <h1 className={styles.srOnly}>MrNewbTracker</h1>

        <button
          type="button"
          className={styles.closeKey}
          style={{
            left: `${(closeRegion.cx - closeRegion.d / 2) * 100}%`,
            top: `${(closeRegion.cy - (closeRegion.d * DEVICE_ASPECT) / 2) * 100}%`,
            width: `${closeRegion.d * 100}%`,
            aspectRatio: '1',
          }}
          onClick={onClose}
          disabled={phase === 'locked'}
          aria-label={labels.close}
        >
          <CloseIcon />
        </button>

        <section className={styles.screen} style={screenStyle} data-tone={tone} aria-label={labels.number}>
          <p className={styles.gps}>
            <span className={styles.gpsDot} aria-hidden />
            <span className={styles.gpsText}>{labels.gps}</span>
          </p>
          <div key={missCount} className={`${styles.numberWrap} ${missCount > 0 && tone === 'miss' ? styles.shake : ''}`}>
            <NumberReadout value={phoneNumber} />
          </div>
          <input
            ref={inputRef}
            className={styles.numberInput}
            value={phoneNumber}
            onChange={(event) => editNumber(() => event.target.value)}
            onKeyDown={onKeyDown}
            inputMode="numeric"
            pattern="[0-9]*"
            autoComplete="off"
            spellCheck={false}
            maxLength={PHONE_NUMBER_MAX_LENGTH}
            disabled={busy}
            aria-label={labels.number}
            aria-describedby={statusId}
          />
          <p id={statusId} className={styles.status} role="status" aria-live="polite">
            {statusText}
          </p>
          {phase === 'pinging' ? <span className={styles.sweep} aria-hidden /> : null}
        </section>

        {keypadLayout.map((action, index) => {
          const key = action.kind === 'digit' ? action.value : action.kind
          const atLimit = action.kind === 'digit' && phoneNumber.length >= PHONE_NUMBER_MAX_LENGTH
          const nothingToEdit = action.kind !== 'digit' && phoneNumber.length === 0
          return (
            <button
              key={key}
              type="button"
              className={`${styles.key} ${busy ? styles.keyBusy : ''}`}
              style={region(keyRegions[index])}
              disabled={atLimit || nothingToEdit}
              onClick={() => handleKey(action)}
              aria-label={action.kind === 'backspace' ? labels.backspace : action.kind === 'clear' ? labels.clear : undefined}
            >
              {action.kind === 'digit' ? action.value : action.kind === 'backspace' ? <BackspaceIcon /> : 'C'}
            </button>
          )
        })}

        <button
          type="submit"
          className={styles.track}
          style={{ ...region(barPlate), '--chars': Math.max(trackText.length, 8) } as CSSProperties}
          disabled={submitLocked || phoneNumber.length === 0}
          aria-busy={phase === 'pinging'}
        >
          {phase === 'pinging' ? <span className={styles.spinner} aria-hidden /> : null}
          <span className={styles.trackText}>{trackText}</span>
        </button>
      </form>
    </div>
  )
}
