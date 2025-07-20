import type { GlobalThemeOverrides } from 'naive-ui'

/**
 * @interface Override Naive's theme colors. 覆盖Naive的主题配色
 * Reference: https://www.naiveui.com/zh-CN/os-theme/docs/customize-theme#调整主题变量
 */
export interface ThemeOverride {
  /**
   * The default theme color, if light and dark are not set, this color will be used as the theme color.
   * 默认的主题颜色，如果不设置light和dark ，将使用这个颜色作为主题色
   */
  defaultColor?: string
  /**
   * Theme colors under light
   * 浅色下的色彩
   */
  light?: GlobalThemeOverrides

  /**
   * Theme colors under dark
   * 深色下的色彩
   */
  dark?: GlobalThemeOverrides
}
