import type { MenuSetting } from '@/shared/typings/menu.d'
import type { MenuOption } from 'naive-ui'
import { type RouteRecordNormalized, type RouteRecordRaw, RouterLink } from 'vue-router'

/**
 * Map routes to menu items
 * 将路由映射为菜单项
 *
 * @param route The route object 路由对象
 * @param fullRoutes All routes 所有路由
 * @param t Internationalization function 国际化函数
 * @param menuSetting Menu Setting 菜单配置
 * @returns Mapped menu option 映射的菜单项
 */
export function mapRoutes(
  route: RouteRecordRaw,
  fullRoutes: RouteRecordNormalized[],
  t: (x: string) => string,
  menuSetting?: MenuSetting,
  mainMenuRootKey?: string,
): MenuOption {
  const menu: MenuOption = {
    key: route.name as string,
    icon: route.meta?.icon ? () => h('div', { class: route.meta?.icon }) : undefined,
  }

  const childRoutes = fullRoutes.filter(r => r.meta.parentName === menu.key)

  if (childRoutes.length > 0 && (menu.key !== mainMenuRootKey || menuSetting?.subMenu.collapsed))
    menu.children = childRoutes.map(childRoute => mapRoutes(childRoute, fullRoutes, t))

  // If there are child menus, make it non-clickable (no RouterLink wrapper)
  // 如果有子菜单，则不可点击(不用RouterLink包裹)
  if (childRoutes.length > 0) {
    menu.label = () => `${t((route.meta?.title || route.name || route.path) as string)}`
  }
  else {
    menu.label = () =>
      h(
        RouterLink,
        { to: { path: route.path } },
        { default: () => `${t((route.meta?.title || route.name || route.path) as string)}` },
      )
  }

  if (menuSetting && menuSetting.mainMenu.collapsed) {
    menu.icon = () =>
      h('div', { class: 'flex flex-col items-center' }, [
        // Menu icon 菜单图标
        h('div', { class: `${route.meta?.icon} ${menuSetting.mainMenu.showLabel ? 'mt-6px' : ''}` }),
        // Icon title 图标下方标题
        menuSetting.mainMenu.showLabel && route.path.split('/').filter(p => p).length <= 1
          ? h(
            'div',
            { class: 'font-size-3.4 w-48px text-center of-hidden whitespace-nowrap mb-2px' },
            {
              default: () => t((route.meta?.title || route.name || route.path) as string),
            },
          )
          : undefined,
      ])
  }

  return menu
}
