import { useCallback, useEffect, useId, useRef, useState, type FormEvent, type KeyboardEvent } from 'react'
import { SevenSegmentReadout, phoneNumberMaxLength } from './SevenSegmentReadout'
import chassisUrl from '../assets/tracker-chassis.webp'
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
}

const keypadLayout = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', ''] as const

/** Survives close/reopen so the dial stays locked for the full cooldown. */
let submitCooldownUntilMs = 0

function sanitizePhoneNumber(value: string) {
  return value.replace(/\D/g, '').slice(0, phoneNumberMaxLength)
}

function formatCooldownLabel(template: string, seconds: number) {
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

type PingResult = { ok: boolean; reason?: string; wait?: number }

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
  const errorId = useId()
  const [phoneNumber, setPhoneNumber] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
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
  }, [refreshCooldown])

  const submitLocked = busy || cooldownLeft > 0

  function appendDigit(value: string) {
    if (busy || value === '') return
    setError('')
    setPhoneNumber((current) => sanitizePhoneNumber(current + value))
    inputRef.current?.focus()
  }

  function handleChange(value: string) {
    setError('')
    setPhoneNumber(sanitizePhoneNumber(value))
  }

  async function pingNumber() {
    if (submitLocked) {
      if (cooldownLeft > 0) {
        setError(formatCooldownLabel(labels.cooldown, cooldownLeft))
      }
      return
    }

    const trimmed = sanitizePhoneNumber(phoneNumber)
    if (!trimmed) {
      setError(labels.empty)
      return
    }

    setBusy(true)
    setError('')
    try {
      const result = await fetchNui<PingResult>(
        'TRACKER_PING',
        { phoneNumber: trimmed },
        { ok: trimmed === '5550147', wait: cooldownSeconds },
      )

      const waitSeconds = typeof result.wait === 'number' ? result.wait : cooldownSeconds
      if (result.ok || result.reason === 'miss' || result.reason === 'cooldown') {
        armSubmitCooldown(waitSeconds)
        refreshCooldown()
      }

      if (result.ok) {
        onClose()
        return
      }

      if (result.reason === 'empty') {
        setError(labels.empty)
      } else if (result.reason === 'noitem') {
        setError(labels.noItem)
      } else if (result.reason === 'cooldown') {
        setError(formatCooldownLabel(labels.cooldown, getCooldownRemainingSeconds() || waitSeconds))
      } else {
        setError(labels.miss)
      }
    } catch {
      setError(labels.miss)
    } finally {
      setBusy(false)
    }
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

  const statusMessage =
    error || (cooldownLeft > 0 ? formatCooldownLabel(labels.cooldown, cooldownLeft) : '')

  return (
    <div className={styles.stage}>
      <form className={styles.shell} onSubmit={onSubmit}>
        <img className={styles.chassis} src={chassisUrl} alt="" draggable={false} />

        <div className={styles.glass}>
          <div className={styles.statusBlock}>
            <p className={styles.statusLabel}>{labels.status}</p>
            <p className={`${styles.gpsRow} ${busy ? styles.gpsBusy : ''}`}>
              <span className={styles.gpsLed} aria-hidden />
              <span>{labels.gps}</span>
            </p>
          </div>

          <label className={styles.readout}>
            <span className={styles.srOnly}>{labels.number}</span>
            <SevenSegmentReadout value={phoneNumber} />
            <input
              ref={inputRef}
              className={styles.numberInput}
              value={phoneNumber}
              onChange={(event) => handleChange(event.target.value)}
              onKeyDown={onKeyDown}
              inputMode="numeric"
              pattern="[0-9]*"
              autoComplete="off"
              spellCheck={false}
              maxLength={phoneNumberMaxLength}
              disabled={busy}
              aria-invalid={Boolean(error)}
              aria-describedby={statusMessage ? errorId : undefined}
            />
          </label>

          <p
            id={errorId}
            className={statusMessage ? styles.error : styles.errorSlot}
            role="status"
            aria-live="polite"
          >
            {statusMessage}
          </p>

          <div className={styles.keypad}>
            {keypadLayout.map((key, index) =>
              key === '' ? (
                <span key={`spacer-${index}`} className={styles.keySpacer} aria-hidden />
              ) : (
                <button
                  key={key}
                  type="button"
                  className={styles.key}
                  disabled={busy || phoneNumber.length >= phoneNumberMaxLength}
                  onClick={() => appendDigit(key)}
                >
                  {key}
                </button>
              ),
            )}
          </div>
        </div>

        <button
          type="submit"
          className={`${styles.dial} ${cooldownLeft > 0 ? styles.dialCooldown : ''}`}
          disabled={submitLocked}
          aria-label={
            cooldownLeft > 0 ? formatCooldownLabel(labels.cooldown, cooldownLeft) : labels.ping
          }
          aria-busy={busy}
        />
      </form>
    </div>
  )
}
