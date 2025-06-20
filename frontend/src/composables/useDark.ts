import { ref } from 'vue'

/**
 * Simple dark mode composable
 */
export function useDark() {
  const isDark = ref(false)

  const toggle = () => {
    isDark.value = !isDark.value
    
    if (isDark.value) {
      document.documentElement.classList.add('dark')
    } else {
      document.documentElement.classList.remove('dark')
    }
  }

  return {
    isDark,
    toggle,
  }
}
