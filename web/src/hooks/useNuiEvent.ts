import { useEffect, useRef } from 'react'
import { isRecord } from '../utils/misc'

export function useNuiEvent<T>(action: string, handler: (data: T) => void) {
  const handlerRef = useRef(handler)

  useEffect(() => {
    handlerRef.current = handler
  }, [handler])

  useEffect(() => {
    const listener = (event: MessageEvent) => {
      if (!isRecord(event.data)) return
      if (event.data.action !== action) return
      if (!('data' in event.data)) return
      handlerRef.current(event.data.data as T)
    }

    window.addEventListener('message', listener)
    return () => window.removeEventListener('message', listener)
  }, [action])
}
