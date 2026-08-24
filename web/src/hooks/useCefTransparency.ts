import { useEffect } from 'react'
import { isEnvBrowser } from '../utils/misc'

const browserPreviewBg = '#5c6570'

function applyCefTransparency() {
  const targets = [document.documentElement, document.body, document.getElementById('root')]
  for (const element of targets) {
    if (!element) continue
    element.style.setProperty('background', 'transparent', 'important')
    element.style.setProperty('background-color', 'rgba(0, 0, 0, 0)', 'important')
  }
  document.documentElement.style.setProperty('color-scheme', 'normal', 'important')
}

function applyBrowserPreview() {
  const targets = [document.documentElement, document.body, document.getElementById('root')]
  for (const element of targets) {
    if (!element) continue
    element.style.setProperty('background', browserPreviewBg, 'important')
    element.style.setProperty('background-color', browserPreviewBg, 'important')
  }
  document.documentElement.classList.add('is-browser')
}

export function useCefTransparency() {
  useEffect(() => {
    if (isEnvBrowser()) {
      applyBrowserPreview()
      return
    }

    applyCefTransparency()
    const observer = new MutationObserver(applyCefTransparency)
    observer.observe(document.documentElement, {
      attributes: true,
      attributeFilter: ['style', 'class'],
    })
    observer.observe(document.body, {
      attributes: true,
      attributeFilter: ['style', 'class'],
    })
    return () => observer.disconnect()
  }, [])
}
