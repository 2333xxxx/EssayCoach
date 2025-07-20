import menuData from './menuData.json'

/**
 * Menu data type 菜单数据类型
 */
export interface MenuRecord {
  /** Name of the menu item 菜单项的名称 #全局唯一# */
  name: string
  /** Path of the menu item 菜单项的路径 */
  path: string
  /** Title of the menu item 菜单项的标题 */
  title: string
  /** Icon of the menu item 菜单项的图标 */
  icon?: string
  /** Extra information of the menu item 菜单项的额外信息 */
  extra?: string
  /** Component associated with the menu item 菜单项关联的组件 */
  component?: string
  /** Redirect path for the menu item 菜单项的重定向路径 */
  redirect?: string
  /** Alias path(s) for the menu item 菜单项的别名路径 */
  alias?: string | string[]
  /** Child menu items 子菜单项 */
  children?: MenuRecord[]
  /** Visibility of the menu item 菜单项的可见性 */
  hidden?: boolean
}

/**
 * Menu data result 菜单数据结果
 */
export type MenuRecordResult = MenuRecord[] | { rootRoutes: MenuRecord[], publicRoutes?: MenuRecord[] }

/**
 * Simulate fetching menu data through a Web API
 * 模拟通过Web API获取菜单数据
 *
 * @returns A promise that resolves to menu data 返回一个包含菜单数据的Promise
 */
export function getMenuData() {
  return new Promise<MenuRecordResult>((resolve) => {
    // Assume the Web API call takes 300 milliseconds to respond
    // 假设Web API调用需要300毫秒来响应
    setTimeout(() => {
      resolve(menuData as any)
    }, 300)
  })
}
