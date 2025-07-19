import type { RouteRecordNormalized } from 'vue-router'

export function getFullRoutes() {
  const router = useRouter()
  return router.getRoutes().map((route) => {
    // Remove dynamic segments from route paths. 从路由路径中移除动态段。
    route.path = route.path.replace(/:[^/?]+(\?|\/|$)\/?/g, '')
    return route
  })
}

export function findRootRoute(routeName: string, fullRoutes: RouteRecordNormalized[]): RouteRecordNormalized | undefined {
  const route = fullRoutes.find(r => r.name === routeName)
  if (!route)
    return undefined
  else if (route.meta.parentName === 'root')
    return route
  else return findRootRoute(route.meta.parentName as string, fullRoutes)
}

export function findRootRouteName(routeName: string, fullRoutes: RouteRecordNormalized[]): string | undefined {
  return findRootRoute(routeName, fullRoutes)?.name as string | undefined
}

export function findParentNames(routeName: string, routes: RouteRecordNormalized[], stopKey: string = 'root'): string[] {
  const routeMap = new Map(routes.map(route => [route.name, route]))

  const parentNames: string[] = []
  let currentRoute = routeMap.get(routeName)

  while (currentRoute?.meta?.parentName && currentRoute.meta.parentName !== stopKey) {
    parentNames.unshift(currentRoute.meta.parentName as string)
    currentRoute = routeMap.get(currentRoute.meta.parentName as string)
  }
  console.log(parentNames)
  return parentNames
}
