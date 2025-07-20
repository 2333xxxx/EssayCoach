<script setup lang="ts">
import type { MenuInst, MenuOption } from 'naive-ui'
import { MenuButtonEnum, MenuPositionEnum } from '@/shared/typings/menu.d'
import { SUB_MENU_COUNT, SUB_MENU_KEY, UPDATE_SUB_MENU_COUNT, UPDATE_SUB_MENU_KEY } from '~/src/shared/constants/symbols'
import { mapRoutes } from '~/src/shared/utils/menuUtil'
import { findParentNames, findRootRouteName, getFullRoutes } from '~/src/shared/utils/routeUtil'

defineOptions({ name: 'SubSidebar' })

// Variables 变量
const { t } = useI18n()
const app = useAppStore()
const route = useRoute()
const fullRoutes = getFullRoutes()

// Inject the menu object 注入菜单对象
const subMenuKey = inject(SUB_MENU_KEY)!
const updateSubMenuKey = inject(UPDATE_SUB_MENU_KEY)!
const subMenuCount = inject(SUB_MENU_COUNT)!
const updateSubMenuCount = inject(UPDATE_SUB_MENU_COUNT)!

/** Reference to component 组件引用 */
const subMenuRef = ref<MenuInst | null>()
const expandedMenuKeys = ref<string[]>([])

/** Collapsed State of sub-menu 副栏菜单收缩状态 */
const collSubMenu = computed({
  get: () => app.menuSetting.subMenu.collapsed,
  set: (val) => {
    if (app.menuSetting.subMenu.collapsed !== val)
      app.setMenuSetting({ subMenu: { collapsed: val } })
  },
})

/** sub-menu data 副栏菜单数据 */
const subMenuOptions = ref<MenuOption[]>([])

/** Load the sub-menu 加载副栏菜单 */
const loadSubMenu = (menuKey: string) => {
  const rootKey = findRootRouteName(menuKey, fullRoutes) ?? menuKey
  updateSubMenuCount(fullRoutes.filter(r => r.meta.parentName === rootKey).length)

  // Update the sub-menu 更新副栏菜单
  if (!collSubMenu.value && subMenuCount.value > 0) {
    subMenuOptions.value = fullRoutes.filter(route => route.meta.parentName === rootKey).map(route => mapRoutes(route, fullRoutes, t))
  }
  else { subMenuOptions.value = [] }

  expandedMenuKeys.value = findParentNames(menuKey, fullRoutes, rootKey)
}

/** Handle main menu key change 处理主菜单键变化 */
const handleSubMenuChange = (menuKey: string, _item?: MenuOption) => {
  if (subMenuKey.value === menuKey && subMenuOptions.value.length > 0)
    return
  updateSubMenuKey(menuKey)
}

// Don't delete: causes sidebar menu to be blank on hot refresh. 勿删：会导致热刷新时副栏菜单空白。
onMounted(() => {
  handleSubMenuChange(route.name as string)
})

const subSidebarProps = computed(() => {
  return {
    width: app.menuSetting.subMenu.width,
    collapseMode: 'width' as 'transform' | 'width',
    collapsed: collSubMenu.value,
    collapsedWidth: 0,
    showTrigger: (app.menuSetting.buttons.includes(MenuButtonEnum.SubMenuStatus) && app.menuSetting.menuPosition === MenuPositionEnum.SIDEBAR ? 'arrow-circle' : false) as boolean | 'bar' | 'arrow-circle',
    onCollapse: () => collSubMenu.value = true,
    onExpand: () => collSubMenu.value = false,
    bordered: !collSubMenu.value,
    contentClass: 'of-x-hidden!',
  }
})

// Expose the menu loading function 公开菜单加载函数
defineExpose({ loadSubMenu })
</script>

<template>
  <!-- Sidebar (desktop): Sub-sidebar 侧边栏(电脑端):副栏 -->
  <NLayoutSider v-if="subMenuCount > 0" v-bind="subSidebarProps">
    <!-- Sub-menu 副栏菜单 -->
    <NMenu
      ref="subMenuRef" :value="subMenuKey" :options="subMenuOptions" :collapsed-icon-size="16" :indent="16"
      :icon-size="16" accordion :on-update:value="handleSubMenuChange" :expanded-keys="expandedMenuKeys"
      :on-update:expanded-keys="(keys) => expandedMenuKeys = keys"
    />
  </NLayoutSider>
</template>
