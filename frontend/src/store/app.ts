import type { DeepPartial } from '@/shared/typings/app.d'
import type { LocaleSetting } from '@/shared/typings/locale.d'
import type { MenuButtonEnum, MenuSetting } from '@/shared/typings/menu.d'
import type { ThemeOverride } from '@/shared/typings/themeOverride.d'
import type { GlobalThemeOverrides } from 'naive-ui'
import { availableLocales } from '@/modules/i18n'
import { DarkSchemeEnum } from '@/shared/constants/darkScheme'
import {
  darkScheme as darkSchemeDefault,
  localeSetting as localDefault,
  menuSetting as menuDefault,
  themeOverride as themeOverrideDefault,
} from '@/shared/settings/appSetting'
import { MenuPositionEnum } from '@/shared/typings/menu.d'
import { useMediaQuery, useNavigatorLanguage } from '@vueuse/core'
import { acceptHMRUpdate, defineStore } from 'pinia'
import { deepMergeObjects } from '~/src/shared/utils/objectUtil'
import { typedLocalStorage } from '~/src/shared/utils/typedLocalStorage'
import { APP_DARK_SCHEME_KEY, APP_LOCALE_KEY, APP_MENU_KEY, APP_THEME_OVERRIDE_KEY } from '../shared/constants/storeKeys'

export const useAppStore = defineStore('app', () => {
  /** Dark scheme: Includes light, dark, and auto. 主题方案：包括 light、dark 和 auto。 builtin */
  const darkScheme = ref<DarkSchemeEnum>(typedLocalStorage.getItem<DarkSchemeEnum>(APP_DARK_SCHEME_KEY) || darkSchemeDefault)

  /**
   * Dark mode: Excludes "auto". When theme-scheme is set to "auto", it will return the theme-mode of the operating system.
   * 主题模式：不包括 auto。当 theme-scheme 设置为 auto 时，将返回操作系统的主题模式。
   */
  const darkMode = computed<DarkSchemeEnum>(() => {
    if (darkScheme.value === DarkSchemeEnum.AUTO)
      return preferredDark.value ? DarkSchemeEnum.DARK : DarkSchemeEnum.LIGHT
    else return darkScheme.value
  })

  /** Is dark mode. 是否深色模式 */
  const isDark = computed(() => darkMode.value === DarkSchemeEnum.DARK)

  const _themeOverride = ref<ThemeOverride>(
    typedLocalStorage.getItem<ThemeOverride>(APP_THEME_OVERRIDE_KEY) || themeOverrideDefault,
  )
  /** Override Naive's theme colors. 覆盖Naive的主题配色 */
  const themeOverride = computed((): GlobalThemeOverrides | undefined => {
    const themeOvr = { ..._themeOverride.value }
    if (!themeOvr.defaultColor && !themeOvr.light && !themeOvr.dark)
      return undefined
    const defaultOverride = !themeOvr.defaultColor
      ? undefined
      : {
          common: {
            primaryColor: themeOvr.defaultColor,
            primaryColorHover: themeOvr.defaultColor,
            primaryColorPressed: themeOvr.defaultColor,
            primaryColorSuppl: themeOvr.defaultColor,
          },
        }
    if (darkMode.value === DarkSchemeEnum.DARK) {
      return themeOvr.dark || defaultOverride || themeOvr.light
    }
    else {
      return themeOvr.light || defaultOverride || themeOvr.dark
    }
  })

  const { isSupported, language } = useNavigatorLanguage()
  const _localeSetting = ref<LocaleSetting>(typedLocalStorage.getItem<LocaleSetting>(APP_LOCALE_KEY) || localDefault)
  /** Locale setting. 区域设置。 */
  const localeSetting = computed<LocaleSetting>(() => {
    const lSet = { ..._localeSetting.value }

    // Default to use browser language 默认使用浏览器语言
    if (!lSet.locale && isSupported.value)
      lSet.locale = language.value

    return lSet
  })

  const _menuSetting = ref<MenuSetting>(typedLocalStorage.getItem<MenuSetting>(APP_MENU_KEY) || menuDefault)
  /** Menu settings 菜单设置 */
  const menuSetting = computed<MenuSetting>(() => {
    const mSet = { ..._menuSetting.value }
    if (!mSet.menuState) {
      if (mSet.mainMenu.collapsed && mSet.mainMenu.showLabel) {
        mSet.menuState = 1
      }
      else if (mSet.mainMenu.collapsed && !mSet.mainMenu.showLabel) {
        mSet.menuState = 2
      }
      else if (!mSet.mainMenu.collapsed) {
        mSet.menuState = 3
      }
    }
    return mSet
  })

  /** Is dark mode. 是否深色模式 */
  const isMobile = useMediaQuery('(max-width: 768px)')

  /** Set theme-scheme 设置主题方案 */
  function setDarkScheme(val: DarkSchemeEnum) {
    darkScheme.value = val // STATE UPDATE
    typedLocalStorage.setItem(APP_DARK_SCHEME_KEY, val)
  }

  /** Toggle dark mode 切换深色模式 */
  function toggleDarkMode() {
    toggleDark()
    nextTick(() => {
      darkScheme.value = typedLocalStorage.getItem<DarkSchemeEnum>(APP_DARK_SCHEME_KEY) || darkSchemeDefault
    })
  }

  /** Set locale settings 设置本地化设置 */
  function setLocaleSetting(setting: Partial<LocaleSetting>) {
    const currSetting = deepMergeObjects(localeSetting.value, setting)
    _localeSetting.value = currSetting // STATE UPDATE
    typedLocalStorage.setItem(APP_LOCALE_KEY, currSetting)
    activateLanguage(localeSetting.value.locale)
  }

  /** Toggle language 切换语言 */
  function toggleLanguage(lang?: string) {
    const currentIndex = availableLocales.indexOf(lang ?? localeSetting.value.locale ?? 'en-US')
    const nextIndex = lang ? currentIndex : (currentIndex + 1) % availableLocales.length
    setLocaleSetting({ locale: availableLocales[nextIndex] })
  }

  /** Set menu settings 设置菜单设置 */
  function setMenuSetting(setting: DeepPartial<MenuSetting>) {
    const currSetting = deepMergeObjects(menuSetting.value, setting)
    _menuSetting.value = currSetting // STATE UPDATE
    typedLocalStorage.setItem(APP_MENU_KEY, currSetting)
  }

  /** Toggle menu position 切换菜单位置 */
  function toggleMenuPosition() {
    if (menuSetting.value.menuPosition === MenuPositionEnum.SIDEBAR)
      setMenuSetting({ menuPosition: MenuPositionEnum.TOP_BAR, topMenu: { showSubMenu: true } })
    else if (menuSetting.value.topMenu.showSubMenu)
      setMenuSetting({ menuPosition: MenuPositionEnum.TOP_BAR, topMenu: { showSubMenu: false } })
    else setMenuSetting({ menuPosition: MenuPositionEnum.SIDEBAR })
  }

  /** Toggle main menu state 切换主栏菜单状态 */
  function toggleMainMenuState() {
    if (isMobile.value)
      setMenuSetting({ mainMenu: { collapsed: !menuSetting.value.mainMenu.collapsed } })
    else if (menuSetting.value.menuState === 1)
      setMenuSetting({ mainMenu: { collapsed: true, showLabel: false }, menuState: 2 })
    else if (menuSetting.value.menuState === 2)
      setMenuSetting({ mainMenu: { collapsed: false, showLabel: false }, menuState: 3 })
    else if (menuSetting.value.menuState === 3)
      setMenuSetting({ mainMenu: { collapsed: true, showLabel: true }, menuState: 1 })
  }

  /** Check if menu button exists display list 检查菜单按钮是否存在于显示列表 */
  function hasMenuButton(button: MenuButtonEnum) {
    return menuSetting.value.buttons.includes(button)
  }

  return {
    darkScheme,
    darkMode,
    isDark,
    localeSetting,
    menuSetting,
    themeOverride,
    isMobile,
    setDarkScheme,
    toggleDarkMode,
    setLocaleSetting,
    toggleLanguage,
    setMenuSetting,
    toggleMenuPosition,
    toggleMainMenuState,
    hasMenuButton,
  }
})

// HMR hot reload HMR热重载
import.meta.hot?.accept(acceptHMRUpdate(useAppStore, import.meta.hot))
