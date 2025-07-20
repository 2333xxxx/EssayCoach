export const ROOT_MENU_KEY = Symbol('rootMenuKey') as InjectionKey<Ref<string>>
export const UPDATE_ROOT_MENU_KEY = Symbol('updateRootMenuKey') as InjectionKey<(menuKey: string) => void>

export const MAIN_MENU_KEY = Symbol('mainMenuKey') as InjectionKey<Ref<string>>
export const UPDATE_MAIN_MENU_KEY = Symbol('updateMainMenuKey') as InjectionKey<(menuKey: string) => void>

export const SUB_MENU_KEY = Symbol('subMenuKey') as InjectionKey<Ref<string>>
export const UPDATE_SUB_MENU_KEY = Symbol('updateSubMenuKey') as InjectionKey<(menuKey: string) => void>

export const SUB_MENU_COUNT = Symbol('subMenuCount') as InjectionKey<Ref<number>>
export const UPDATE_SUB_MENU_COUNT = Symbol('updateSubMenuCount') as InjectionKey<(count: number) => void>
