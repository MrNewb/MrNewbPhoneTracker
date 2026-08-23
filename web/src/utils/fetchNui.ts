import { isEnvBrowser } from './misc'

export class NuiRequestError extends Error {
  event: string
  status?: number

  constructor(event: string, status?: number, message?: string) {
    super(message ?? `NUI request failed: ${event}`)
    this.name = 'NuiRequestError'
    this.event = event
    this.status = status
  }
}

export async function fetchNui<T>(event: string, data?: unknown, mock?: T): Promise<T> {
  if (isEnvBrowser()) {
    if (mock !== undefined) return mock
    throw new NuiRequestError(event, undefined, `NUI mock missing for ${event} in browser`)
  }

  const resource =
    (window as Window & { GetParentResourceName?: () => string }).GetParentResourceName?.() ?? 'nui-frame-app'

  let response: Response
  try {
    response = await fetch(`https://${resource}/${event}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json; charset=UTF-8' },
      body: JSON.stringify(data ?? {}),
    })
  } catch (error) {
    throw new NuiRequestError(event, undefined, error instanceof Error ? error.message : 'Network error')
  }

  if (!response.ok) {
    throw new NuiRequestError(event, response.status, `HTTP ${response.status}`)
  }

  const text = await response.text()
  if (!text) return { ok: true } as T

  try {
    return JSON.parse(text) as T
  } catch {
    return { response: text } as T
  }
}
