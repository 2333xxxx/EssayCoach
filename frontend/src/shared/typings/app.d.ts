import type { App } from 'vue'
import type { RouteMeta, RouteRecordRaw } from 'vue-router'

export type UserModule = (ctx: App) => void | Promise<void>

export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
}

// @ts-expect-error // Ignore the error of the unused variable
export interface AppRouteRecordRaw extends Omit<RouteRecordRaw, 'meta' | 'children'> {
  name: string
  meta: RouteMeta
  component?: Component | string
  components?: Component
  children?: AppRouteRecordRaw[]
  props?: Recordable
  fullPath?: string
}
