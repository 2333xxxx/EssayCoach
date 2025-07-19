import type { Router } from 'vue-router'
import { availableLocales } from '@/modules/i18n'
import { LocaleEnum } from '@/shared/typings/locale.d'

export function createRouterGuards(router: Router) {
  const app = useAppStore()
  const tabs = useTabsStore()

  router.beforeEach(async (to, _) => {
    // Get the language parameter in the route or use the default language
    // 获取路由中的语言参数或者使用默认语言
    let lang = (to.params.lang as string) || app.localeSetting.locale || LocaleEnum.enUS
    const matchLangs = availableLocales.filter(item => item.toLowerCase() === lang.toLowerCase())
    lang = matchLangs.length > 0 ? matchLangs[0] : LocaleEnum.enUS

    // Update language 更新语言
    if (app.localeSetting.locale !== lang)
      app.toggleLanguage(lang)

    // Is an exception language (not displayed in the route)
    // 是否例外的语言(不显示在路由中)
    const inLocaleExcludes = app.localeSetting.inRouteExclude.some((item: any) => item.toLowerCase() === lang.toLowerCase())

    // Correctness of route path 处理路由路径的准确性
    let validPath = to.path.replace(new RegExp(`^/${lang}`, 'gi'), '')
    if (!app.localeSetting.inRoute && validPath !== to.path) {
      return { path: validPath, query: to.query, hash: to.hash }
    }
    else if (app.localeSetting.inRoute) {
      if (!inLocaleExcludes)
        validPath = `/${lang.toLowerCase()}${validPath}`
      if (validPath !== to.path)
        return { path: validPath, query: to.query, hash: to.hash }
    }

    // 多标签
    if (to.name && to.fullPath) {
      tabs.addTab(to)
    }
  })
}
