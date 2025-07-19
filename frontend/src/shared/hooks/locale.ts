import { i18n, setOrLoadLanguageAsync } from '@/modules/i18n'
import { router } from '@/router'
import { useNavigatorLanguage } from '@vueuse/core'
import { dateEnUS, dateJaJP, dateKoKR, dateZhCN, dateZhTW, enUS, jaJP, koKR, zhCN, zhTW } from 'naive-ui'
import type { NDateLocale, NLocale } from 'naive-ui'

/**
 * Define return type.
 * 定义返回类型
 */
interface NaiveLocale {
  locale: NLocale
  dateLocale: NDateLocale
  display: string
}

/**
 * Locale mapping object.
 * Locale 映射对象
 */
export const localeMap: Record<string, NaiveLocale> = {
  'en-US': { locale: enUS, dateLocale: dateEnUS, display: 'English (United States)' },
  'ja-JP': { locale: jaJP, dateLocale: dateJaJP, display: '日本語 (日本)' },
  'ko-KR': { locale: koKR, dateLocale: dateKoKR, display: '한국어 (대한민국)' },
  'zh-CN': { locale: zhCN, dateLocale: dateZhCN, display: '中文 (简体)' },
  'zh-TW': { locale: zhTW, dateLocale: dateZhTW, display: '中文 (繁體)' },
}

/**
 * Get Naive UI locale
 * 获取 Naive UI 的本地化
 *
 * @param {string} [locale] - 语言区域代码
 * @returns {NaiveLocale} 包含 locale 和 dateLocale 的对象
 */
export function getNaiveLocale(locale: string = 'en-US'): NaiveLocale {
  locale = locale.replace('_', '-')

  // Attempt to get the locale directly from the map
  // 尝试直接从映射中获取本地化设置
  if (localeMap[locale]) {
    return localeMap[locale]
  }

  // Split the locale into parts
  // 将本地化代码拆分成部分
  const [language] = locale.split('-')

  // Try to find the first matching locale for the simple language code
  // 尝试找到第一个匹配的简单语言代码的本地化设置
  for (const key in localeMap) {
    if (key.startsWith(language)) {
      return localeMap[key]
    }
  }

  return { locale: enUS, dateLocale: dateEnUS, display: 'English (United States)' }
}

/**
 * Get locale display
 * 获取本地化名称
 *
 * @param {string} [locale] - 语言区域代码
 * @returns {string} 用于前端显示的名称
 */
export function getLanguageDisplay(locale: string = 'en-US'): string {
  locale = locale.replace('_', '-')

  // Attempt to get the label directly from the map
  // 尝试直接从映射中获取标签
  if (localeMap[locale].display) {
    return localeMap[locale].display
  }

  // Split the locale into parts
  // 将本地化代码拆分成部分
  const [language] = locale.split('-')

  // Try to find the first matching label for the simple language code
  // 尝试找到第一个匹配的简单语言代码的标签
  for (const key in localeMap) {
    if (key.startsWith(language)) {
      return localeMap[key].display
    }
  }

  return 'Unknown'
}

/**
 * Get locale name
 * 获取语言名称
 *
 * @param {string} [locale] - 语言区域代码
 * @returns {string} 用于前端显示的名称
 */
export function getLanguageName(locale: string = 'en-US'): string {
  locale = locale.replace('_', '-')

  // Attempt to get the label directly from the map
  // 尝试直接从映射中获取标签
  if (localeMap[locale]) {
    return locale
  }

  // Split the locale into parts
  // 将本地化代码拆分成部分
  const [language] = locale.split('-')

  // Try to find the first matching label for the simple language code
  // 尝试找到第一个匹配的简单语言代码的标签
  for (const key in localeMap) {
    if (key.startsWith(language)) {
      return key
    }
  }

  return 'en-US'
}

/**
 * Browser language
 * 浏览器语言
 */
export const browserLanguage = useNavigatorLanguage()

/**
 * Update the locale setting.
 * 更新区域设置。
 *
 * @param locale - The locale setting to apply. 区域设置。
 */
export async function activateLanguage(locale?: string) {
  const lang = getLanguageName(locale ?? browserLanguage.language.value)

  // Load the appropriate language setting asynchronously.
  // 异步加载适当的语言设置。
  await setOrLoadLanguageAsync(lang)

  // Set the 'lang' attribute of the HTML root element based on the locale setting or browser language.
  // 根据区域设置或浏览器语言设置HTML根元素的'lang'属性。
  document.documentElement.setAttribute('lang', lang)

  // Update the document title based on the current route's metadata and the app's title.
  // 根据当前路由的元数据和应用程序标题更新文档标题。
  const routeTitle = router.currentRoute.value.meta.title as string
  if (router.currentRoute.value.meta.title)
    document.title = `${i18n.global.t(routeTitle)} | ${import.meta.env.VITE_APP_TITLE}`
}
