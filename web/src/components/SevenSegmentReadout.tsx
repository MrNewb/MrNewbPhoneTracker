import styles from './SevenSegmentReadout.module.css'

export const phoneNumberMaxLength = 10

const segmentBits: Record<string, number> = {
  '0': 0b0111111,
  '1': 0b0000110,
  '2': 0b1011011,
  '3': 0b1001111,
  '4': 0b1100110,
  '5': 0b1101101,
  '6': 0b1111101,
  '7': 0b0000111,
  '8': 0b1111111,
  '9': 0b1101111,
  ' ': 0b0000000,
}

function Digit({ value }: { value: string }) {
  const bits = segmentBits[value] ?? 0
  const on = (index: number) => (bits & (1 << index)) !== 0

  return (
    <svg className={styles.digit} viewBox="0 0 48 80" aria-hidden>
      <polygon className={on(0) ? styles.segOn : styles.segOff} points="12,6 36,6 32,12 16,12" />
      <polygon className={on(1) ? styles.segOn : styles.segOff} points="38,8 42,12 42,36 36,40 32,36 32,14" />
      <polygon className={on(2) ? styles.segOn : styles.segOff} points="36,42 42,46 42,70 38,74 32,68 32,46" />
      <polygon className={on(3) ? styles.segOn : styles.segOff} points="12,68 16,62 32,62 36,68 32,74 16,74" />
      <polygon className={on(4) ? styles.segOn : styles.segOff} points="6,46 12,42 16,46 16,68 10,74 6,70" />
      <polygon className={on(5) ? styles.segOn : styles.segOff} points="6,12 10,8 16,14 16,36 12,40 6,36" />
      <polygon className={on(6) ? styles.segOn : styles.segOff} points="14,36 18,32 30,32 34,36 30,40 18,40" />
    </svg>
  )
}

export function SevenSegmentReadout({ value }: { value: string }) {
  const cleaned = value.replace(/\D/g, '').slice(0, phoneNumberMaxLength)
  const padded = cleaned.padStart(phoneNumberMaxLength, ' ')

  return (
    <div className={styles.readoutFace} aria-hidden>
      {padded.split('').map((char, index) => (
        <Digit key={index} value={char} />
      ))}
    </div>
  )
}
