import type { App } from 'vue'
import type { RouteRecordRaw } from 'vue-router'
import { createRouter, createWebHistory } from 'vue-router'
import { getMenuData, type MenuRecord } from '~/src/api-service/menuApi'
import { i18n } from '../modules/i18n'
import { createRouterGuards } from './guard'
import { dynamicImport } from './helper'

/** 路由Path中的区域参数 */
export const LOCALE_PARAM = '/:lang([a-z]{2}-[A-Za-z]{2})?'

/**
 * What is its function? Mainly used to work with the i18n Ally plugin to display the corresponding translation.
 * 什么作用？主要用于配合i18n Ally插件显示对应的翻译。
 */
const t = (key: string) => key

/**
 * Root route based on layout.
 * 基于布局的根路由。
 */
export const RootRoute: RouteRecordRaw = {
  // Language code is an optional parameter, only supports two-part language codes like 'zh-CN', 'zh-TW'.
  // 语言代码为可选参数，仅支持'zh-CN', 'zh-TW' 两段式语言代码
  path: `${LOCALE_PARAM}/`,
  name: 'root',
  component: () => import('@/layouts/default.vue'),
  meta: { title: 'Root' },
  redirect: '',
  children: [],
}

/**
 * Public routes that do not use layout and do not require permission verification.
 * 公开路由，不使用布局且无需权限验证。
 */
export const PublicRoutes: RouteRecordRaw[] = [
  {
    path: `${LOCALE_PARAM}/login`,
    name: 'login',
    component: () => import('@/views/login.vue'),
    meta: { title: t('login.title') },
  },
  // Catch all unmatched routes, must be placed at the end.
  // 捕获所有未匹配的路由，必须放在最后一个。
  {
    path: '/:pathMatch(.*)*',
    name: 'NotFound',
    component: () => import('@/shared/_builtin_views_/fallback/404.vue'),
  },
]

// Catch all unmatched routes 捕获所有未匹配的路由
export const NotFoundRoute: RouteRecordRaw = {
  path: '/:pathMatch(.*)*',
  name: 'NotFound',
  component: () => import('@/shared/_builtin_views_/fallback/404.vue'),
}

/**
 * Combine RootRoute and PublicRoutes.
 * 合并 RootRoute 和 PublicRoutes。
 */
const mergeRoutesWithParent = (parentName?: string, routes?: any[]) => {
  routes = routes ?? [RootRoute, ...PublicRoutes]
  return routes.map((route: RouteRecordRaw) => {
    if (parentName)
      route.meta = { parentName, ...route.meta }
    if (route.children)
      route.children = mergeRoutesWithParent(route.name as string, route.children)
    return route
  })
}

/**
 * Create router. 创建路由。
 */
export const router = createRouter({
  history: createWebHistory(),
  routes: mergeRoutesWithParent(),
  strict: true,
  scrollBehavior: () => ({ left: 0, top: 0 }),
})

export default router

/**
 * Convert JSON format route configuration to Vue Router configuration.
 * 将 JSON 格式的路由配置转换为 Vue 路由配置。
 * @param routes JSON format route array. JSON 格式的路由数组。
 * @return Vue Router configuration array. Vue 路由配置数组。
 */
function transformJsonRoutes(routes: MenuRecord[], parentName?: string): RouteRecordRaw[] {
  return routes.map((route: MenuRecord) => {
    // Destructure the original object, separating path, name, redirect, children, and other attributes (into rest).
    // 解构原始对象，分离出 path, name, redirect, children 和其他属性（放入 rest 中）。
    const { path, name, redirect, children, component, ...rest } = route

    // Create RouteRecordRaw object. 创建 RouteRecordRaw 对象。
    const routeRaw = { path, name, redirect, meta: { ...rest } } as RouteRecordRaw

    if (route.component) {
      routeRaw.component = dynamicImport(route.component)
    }

    if (route.children && route.children.length > 0)
      routeRaw.children = transformJsonRoutes(route.children, route.name)

    if (parentName)
      routeRaw.meta = { parentName, ...routeRaw.meta }

    // Return the route. 返回路由。
    return routeRaw
  })
}

/**
 * Set dynamic routes. 设置动态路由。
 */
async function setDynamicRoutes() {
  // Call API to get JSON format route data.
  // 调用 API 获取 JSON 格式的路由数据。
  const menuData = await getMenuData()

  const menuDataObject = menuData as { rootRoutes: MenuRecord[], publicRoutes?: MenuRecord[] }
  if (menuDataObject.publicRoutes !== undefined) {
    menuDataObject.publicRoutes = menuDataObject.publicRoutes.map((route) => {
      if (!route.path.startsWith(`${LOCALE_PARAM}/`)) {
        return { ...route, path: `${LOCALE_PARAM}${route.path}` }
      }
      return route
    })
  }

  // Transform root route data and add to router.
  // 转换 root 路由数据并添加至路由器。
  const rootRoutes = transformJsonRoutes(Array.isArray(menuData) ? menuData : menuData.rootRoutes, 'root')
  rootRoutes.forEach((route: RouteRecordRaw) => router.addRoute('root', route))

  // Set the redirect for the "root" route (if not set)
  // 为 "root" 路由设置重定向(如果没有设置的话)
  const rootRoute = router.getRoutes().find(route => route.name === 'root')
  if (rootRoute && rootRoutes.length > 0 && !rootRoute.redirect)
    rootRoute.redirect = rootRoutes[0].path.startsWith('/') ? rootRoutes[0].path : `/${rootRoutes[0].path}`

  // Transform public route data and add to router.
  // 转换 public 路由数据并添加至路由器。
  const publicRoutes = transformJsonRoutes(Array.isArray(menuData) ? [] : menuData.publicRoutes ?? [])
  publicRoutes.forEach((route: RouteRecordRaw) => router.addRoute(route))

  // Return Vue Router instance. 返回 Vue Router 实例。
  return router
}

/**
 * Setup the router. 挂载路由。
 */
export async function setupRouter(app: App<Element>) {
  await setDynamicRoutes()
  app.use(router)

  // Create router guards. 创建路由守卫。
  createRouterGuards(router)

  // Set page title. 设置页面标题。
  router.afterEach((to) => {
    document.title = `${i18n.global.t((to?.meta?.title as string) ?? '')} | ${import.meta.env.VITE_APP_TITLE}`
  })
}
