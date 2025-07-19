/**
 * @interface Locale Setting 区域设置
 */
export interface LocaleSetting {
  /** Whether to display the picker 是否显示选择器 */
  showButton: boolean
  /**
   * Current language, do not set to use browser language
   * 当前语言，不设置时使用浏览器语言
   */
  locale?: string
  /**
   * Whether to include the language option in the route
   * 是否把语言选项包含在路由中
   */
  inRoute: boolean
  /**
   * The language option that is not included in the route
   * 不包含在路由的语言选项
   */
  inRouteExclude: string[]
}

/**
 * @constant Available locale enum. 可选的区域枚举。
 */
export enum LocaleEnum {
  zhCN = 'zh-CN',
  enUS = 'en-US',
}
