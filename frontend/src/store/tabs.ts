import type { RouteLocationNormalizedGeneric } from 'vue-router'
import { defineStore } from 'pinia'

export const useTabsStore = defineStore('tabs', () => {
  const tabs = ref<RouteLocationNormalizedGeneric[]>([])
  const activeTab = ref('')

  const addTab = async (route: RouteLocationNormalizedGeneric) => {
    if (!tabs.value.some(tab => tab.name === route.name))
      tabs.value.push(route)
    await nextTick()
    activeTab.value = route.fullPath
  }

  const removeTab = async (removePath: string) => {
    if (tabs.value.length === 1)
      return
    const tabIndex = tabs.value.findIndex(tab => tab.fullPath === removePath)
    if (tabIndex !== -1) {
      if (activeTab.value === removePath) {
        const nextTab = tabs.value[tabIndex + 1] || tabs.value[tabIndex - 1]
        if (nextTab) {
          activeTab.value = nextTab.fullPath
        }
      }
    }
    await nextTick()
    tabs.value.splice(tabIndex, 1)
  }

  const removeOtherTabs = async (currentPath: string) => {
    tabs.value = tabs.value.filter(tab => tab.fullPath === currentPath)
  }
  const removeRightTabs = async (currentPath: string) => {
    const activeIndex = tabs.value.findIndex(tab => tab.fullPath === currentPath)
    if (activeIndex !== -1) {
      tabs.value = tabs.value.slice(0, activeIndex + 1)
    }
  }

  return {
    tabs,
    activeTab,
    addTab,
    removeTab,
    removeOtherTabs,
    removeRightTabs,
  }
})
