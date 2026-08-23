export const isEnvBrowser = (): boolean =>
  !(window as Window & { invokeNative?: unknown }).invokeNative

export function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value)
}
