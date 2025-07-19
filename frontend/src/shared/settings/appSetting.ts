import { DarkSchemeEnum } from '@/shared/constants/darkScheme'
import { MenuButtonEnum, MenuPositionEnum } from '@/shared/typings/menu.d'
import type { LocaleSetting } from '@/shared/typings/locale.d'
import type { MenuSetting } from '@/shared/typings/menu.d'
import type { ThemeOverride } from '@/shared/typings/themeOverride.d'

/** Default dark-scheme 默认主题方案 */
export const darkScheme = DarkSchemeEnum.AUTO

/**
 * Override Naive's theme colors. 覆盖Naive的主题配色
 * Reference: https://www.naiveui.com/zh-CN/os-theme/docs/customize-theme#调整主题变量
 */
export const themeOverride: ThemeOverride = {
  // The default color,  if light and dark are not set, this color will be used as the theme color.
  // 默认的主题颜色，如果不设置light和dark ，将使用这个颜色作为主题色
  defaultColor: '#646CFF',

  // Theme colors under light 浅色下的配色
  light: undefined,

  // Theme colors under dark 深色下的配色
  dark: undefined,
}

/** Default locale setting 默认区域设置 */
export const localeSetting: LocaleSetting = {
  // Whether to display button 是否显示按钮
  showButton: true,

  // Current language, do not set to use browser language
  // 当前语言，不设置时使用浏览器语言
  locale: undefined,

  // Whether to include the language option in the route
  // 是否把语言选项包含在路由中
  inRoute: false,

  // The language option that is not included in the route
  // 不包含在路由的语言选项
  inRouteExclude: [],
}

/** Default menu Setting 默认菜单设置 */
export const menuSetting: MenuSetting = {
  // Displayed menu button set 显示的菜单按钮集合
  buttons: [
    MenuButtonEnum.ThemeDrawer,
    MenuButtonEnum.MenuPosition,
    MenuButtonEnum.MainMenuStatus,
    MenuButtonEnum.SubMenuStatus,
    MenuButtonEnum.ThemeMode,
  ],

  // Menu position, optional Sidebar sidebar | TopBar top bar, if TopBar top bar, all other configurations will be useless
  // 菜单位置，可选 Sidebar侧栏 | TopBar顶栏，如果为 TopBar顶栏，其他所有配置将无用
  menuPosition: MenuPositionEnum.SIDEBAR,

  // Top-menu settings 顶栏菜单设置
  topMenu: {
    showSubMenu: true,
  },

  // Main-menu settings 主栏菜单设置
  mainMenu: {
    collapsed: true,
    width: 120,
    widthColl: 70,
    widthSingle: 180,
    widthMobile: 200,
    inverted: true,
    showLabel: true,
  },

  // Sub-menu settings 副栏菜单设置
  subMenu: {
    collapsed: false,
    width: 160,
  },
}
