// Measured from web/src/assets/tracker-device.webp (698x1518). All values are fractions of the image.
export type Region = { x: number; y: number; w: number; h: number }

export const DEVICE_ASPECT = 698 / 1518

export const screenRegion: Region = { x: 0.1175, y: 0.226, w: 0.7622, h: 0.2681 }

// Row by row: 1 2 3 / 4 5 6 / 7 8 9 / delete 0 clear
export const keyRegions: Region[] = [
  { x: 0.1304, y: 0.5119, w: 0.2335, h: 0.0599 },
  { x: 0.3825, y: 0.5119, w: 0.2335, h: 0.0599 },
  { x: 0.6347, y: 0.5119, w: 0.2321, h: 0.0599 },
  { x: 0.1304, y: 0.581, w: 0.2335, h: 0.0593 },
  { x: 0.3825, y: 0.581, w: 0.2335, h: 0.0586 },
  { x: 0.6347, y: 0.581, w: 0.2335, h: 0.0593 },
  { x: 0.1304, y: 0.6489, w: 0.2335, h: 0.0593 },
  { x: 0.3825, y: 0.6489, w: 0.2335, h: 0.0593 },
  { x: 0.6347, y: 0.6489, w: 0.2335, h: 0.0593 },
  { x: 0.1304, y: 0.7174, w: 0.2335, h: 0.0613 },
  { x: 0.3825, y: 0.7174, w: 0.2335, h: 0.0613 },
  { x: 0.6347, y: 0.7174, w: 0.2321, h: 0.0613 },
]

export const barRegion: Region = { x: 0.139, y: 0.7925, w: 0.7221, h: 0.0527 }

export const closeRegion = { cx: 0.8066, cy: 0.1831, d: 0.1146 }
