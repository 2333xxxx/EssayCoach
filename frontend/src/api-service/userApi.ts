import type { MenuRecord } from './menuApi'
import userData from './menuData.json'

/**
 * Login 账号登录
 *
 * @returns 账号登录
 */
export function login() {
  return new Promise<{ account: string, password: string }>((resolve) => {
    setTimeout(() => {
      resolve({ token: 'token123' } as any)
    }, 600)
  })
}

/**
 * 获取用户信息
 *
 * @returns 获取用户信息
 */
export function userInfo() {
  return new Promise<{ rootRoutes: MenuRecord[], publicRoutes?: MenuRecord[] } | MenuRecord[]>((resolve) => {
    setTimeout(() => {
      resolve(userData as any)
    }, 600)
  })
}
