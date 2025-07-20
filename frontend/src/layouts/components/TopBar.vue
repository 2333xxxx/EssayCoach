<script setup lang="ts">
import type { MenuInst } from 'naive-ui'
import { availableLocales } from '@/modules/i18n'
import SyIconButton from '@/shared/components/SyIconButton.vue'
import { MenuButtonEnum, MenuPositionEnum } from '@/shared/typings/menu.d'
import LayoutLogo from '~/src/layouts/components/LayoutLogo.vue'
import { SUB_MENU_COUNT } from '~/src/shared/constants/symbols'
import { renderProfileHeader, renderUnoIcon } from '~/src/shared/utils/componentUtil'
import { mapRoutes } from '~/src/shared/utils/menuUtil'
import { findRootRouteName, getFullRoutes } from '~/src/shared/utils/routeUtil'

defineOptions({ name: 'TopBar' })

const emit = defineEmits(['action', 'keyChange'])

// Variables 变量
const { t } = useI18n()
const app = useAppStore()
const router = useRouter()
const route = useRoute()
const fullRoutes = getFullRoutes()

// Inject the number of sub-menu items 注入副栏菜单项数量
const subMenuCount = inject(SUB_MENU_COUNT, ref(0))

// Component references 组件引用
const topMenuRef = ref<MenuInst | null>()

/** Whether it is top bar layout 是否顶栏菜单布局 */
const isTopBarLayout = computed(() => app.menuSetting.menuPosition === MenuPositionEnum.TOP_BAR)

/** Whether to show main menu status switch button 是否显示主菜单状态切换按钮 */
const showMainMenuStatusButton = computed(() => app.menuSetting.buttons.includes(MenuButtonEnum.MainMenuStatus))

/** Selected item in top menu 顶栏菜单选中项 */
const topMenuKey = ref<string>()

/** Top menu items 顶栏菜单项 */
const topMenuOptions = computed(() => {
  const routers = fullRoutes.filter(route => route.meta.parentName === 'root').filter(route => !route.meta?.hidden) ?? []
  return routers.map(route => mapRoutes(route, fullRoutes, t))
})

/** Menu state switch icon 菜单状态切换图标 */
const menuStateIcon = computed(() => {
  const menuIconMap = { 1: 'i-line-md:download-off-outline', 2: 'i-line-md:menu-fold-right', 3: 'i-line-md:menu-unfold-left' }
  return app.isMobile ? 'i-line-md:menu-fold-right' : menuIconMap[app.menuSetting.menuState!] || ''
})

/** Toggle main-menu status 切换主栏菜单状态 */
const toggleMainMenu = () => app.isMobile ? emit('action', 'toggleMobileDrawer') : app.toggleMainMenuState()

const refreshTopMenu = () => {
  topMenuKey.value = (app.menuSetting.subMenu.collapsed ? route.name : route.matched[1].name) as string
  topMenuRef.value?.showOption(topMenuKey.value)
  emit('keyChange', toRaw(topMenuKey.value))
}

/** show theme drawer 显示主题设置抽屉 */
const toggleThemeDrawer = () => {
  emit('action', 'toggleThemeDrawer')
}

const toggleLanguage = (lang: string) => {
  router.push({
    path: `/${lang.toLowerCase()}${route.path.replace(new RegExp(`^/${route.params.lang}/`, 'gi'), '/')}`,
    query: route.query,
    hash: route.hash,
  })
}

const onTopMenuKeyChange = (key: string) => {
  const mainMenuRootKey = findRootRouteName(key, fullRoutes) ?? key
  emit('keyChange', mainMenuRootKey)
}

const profileOptions = computed(() => [
  {
    key: 'header',
    type: 'render',
    render: renderProfileHeader({
      name: t('author'),
      intro: t('intro'),
      avatar: 'https://07akioni.oss-cn-beijing.aliyuncs.com/demo1.JPG',
    }),
  },
  { type: 'divider', key: 'header-divider' },
  { key: 'profile', icon: renderUnoIcon('i-carbon:user-avatar-filled-alt'), label: t('profileMenu.profile') },
  { key: 'settings', icon: renderUnoIcon('i-carbon:settings'), label: t('profileMenu.settings') },
  { type: 'divider', key: 'logout-divider' },
  { key: 'logout', icon: renderUnoIcon('i-carbon:logout'), label: t('profileMenu.logout') },
])

const profileSelect = (key: string | number) => {
  switch (key) {
    case 'profile':
      router.push('/profile')
      break
    case 'settings':
      router.push('/settings')
      break
    case 'logout':
      router.push('/login')
      break
  }
}

onMounted(() => {
  topMenuKey.value = (!app.menuSetting.topMenu.showSubMenu ? route.name : route.matched[1].name) as string
  topMenuRef.value?.showOption(topMenuKey.value)
})

const langs = computed(() => availableLocales.map(locale => ({ label: getLanguageDisplay(locale), key: locale })))

/** Exposes 公开对象 */
defineExpose({ refreshTopMenu })

const logoProps = computed(() => {
  return {
    hideLogo: app.menuSetting.menuPosition !== MenuPositionEnum.TOP_BAR,
    class: app.menuSetting.menuPosition !== MenuPositionEnum.TOP_BAR ? 'b-r-1' : '',
    style: app.menuSetting.menuPosition !== MenuPositionEnum.TOP_BAR ? `width:${app.menuSetting.subMenu.width}px` : `width:${app.menuSetting.subMenu.width - 30}px`,
  }
})
</script>

<template>
  <!-- Left section of the top bar 头部左侧区 -->
  <NLayoutHeader bordered>
    <div h-header flex-right-center gap-x-4>
      <!-- Top logo 顶栏Logo -->
      <LayoutLogo
        v-if="isTopBarLayout || (!app.menuSetting.subMenu.collapsed && app.menuSetting.mainMenu.collapsed && subMenuCount > 0)"
        v-bind="logoProps" flex-nowrap
      />
      <!-- Top menu 顶栏菜单 -->
      <div v-if="!app.isMobile && isTopBarLayout" flex-1>
        <NMenu
          ref="topMenuRef" v-model:value="topMenuKey" mode="horizontal" :options="topMenuOptions" :icon-size="20.5"
          responsive :indent="16" @update:value="onTopMenuKeyChange"
        />
      </div>
      <!-- Left section of the top bar 头部左侧区 -->
      <div
        v-if="(!isTopBarLayout && showMainMenuStatusButton) || app.isMobile" h-full flex flex-1 items-center gap-x-4
        :class="isTopBarLayout || (!app.menuSetting.subMenu.collapsed && app.menuSetting.mainMenu.collapsed && subMenuCount > 0) ? '' : 'pl-2'"
      >
        <SyIconButton button :icon="menuStateIcon" @click="toggleMainMenu" />
      </div>
      <!-- Right section of the top bar 头部右侧区 -->
      <div h-full flex-right-center gap-1.5 p-r-3>
        <SyIconButton
          v-if="app.menuSetting.topMenu.showSubMenu && isTopBarLayout && !app.isMobile" button
          icon="i-carbon:side-panel-close" @click="app.toggleMenuPosition"
        />
        <SyIconButton
          v-else-if="!app.isMobile" button
          :icon="`i-carbon:align-${isTopBarLayout ? 'horizontal-left' : 'vertical-top'}`"
          @click="app.toggleMenuPosition"
        />
        <SyIconButton
          v-if="app.menuSetting.buttons.includes(MenuButtonEnum.ThemeMode)" button
          :icon="`i-line-md:${app.isDark ? 'sunny-filled' : 'moon-filled '}`" hover-class-dark="text-yellow!"
          @click="app.toggleDarkMode"
        />
        <NDropdown
          v-if="app.localeSetting.showButton" trigger="click" :options="langs" :show-arrow="true"
          @select="(key: string) => toggleLanguage(key)"
        >
          <div>
            <SyIconButton button icon="i-carbon:language" />
          </div>
        </NDropdown>
        <SyIconButton
          v-if="!app.isMobile && app.menuSetting.buttons.includes(MenuButtonEnum.ThemeDrawer)" button
          icon="i-carbon:cookie" @click="toggleThemeDrawer"
        />
        <NDropdown :options="profileOptions" trigger="click" @select="profileSelect">
          <SyIconButton
            button icon="i-carbon:user-avatar" size="1.3em" style="font-size:16px !important;"
            :text="t('author')"
          />
        </NDropdown>
      </div>
    </div>
  </NLayoutHeader>
</template>
