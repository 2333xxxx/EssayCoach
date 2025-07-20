import { useDark, usePreferredDark, useToggle } from '@vueuse/core'
import { APP_DARK_SCHEME_KEY } from '../constants/storeKeys'

export const isDark = useDark({ storageKey: APP_DARK_SCHEME_KEY })
export const toggleDark = useToggle(isDark)
export const preferredDark = usePreferredDark()
