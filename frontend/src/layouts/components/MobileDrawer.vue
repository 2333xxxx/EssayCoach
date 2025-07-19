<script setup lang="ts">
import { darkTheme, type MenuInst } from 'naive-ui'
import LayoutLogo from '~/src/layouts/components/LayoutLogo.vue'
import { mapRoutes } from '~/src/shared/utils/menuUtil'
import { getFullRoutes } from '~/src/shared/utils/routeUtil'

defineOptions({ name: 'MobileDrawer' })

// Variables 变量
const { t } = useI18n()
const app = useAppStore()
const route = useRoute()
const fullRoutes = getFullRoutes()

const drawerActive = ref(false)

// Reference to component 组件引用
const mobileMenuRef = ref<MenuInst | null>()

/** Menu setting 菜单设置 */
const menuSetting = computed(() => app.menuSetting)

/** Main column reverse color 主栏反转颜色 */
const mainMenuInverted = computed({
  get: () => menuSetting.value.mainMenu.inverted,
  set: val => app.setMenuSetting({ mainMenu: { inverted: val } }),
})

/** Selected item in main menu 主栏菜单选中项 */
const mobileMenuKey = ref<string>()

/** Theme setting 主题设置 */
const theme = computed(() => mainMenuInverted.value ? darkTheme : null)

/** Main menu options 主栏菜单项 */
const mobileMenuOptions = computed(() => {
  const routers = fullRoutes.filter(route => route.meta.parentName === 'root').filter(route => !route.meta?.hidden) ?? []
  return routers.map(route => mapRoutes(route, fullRoutes, t))
})

/** Handle mobile menu key change 处理移动菜单键更改 */
const handleMobileMenuKeyChange = (key: string) => {
  mobileMenuKey.value = key
  drawerActive.value = false
}

const show = () => {
  mobileMenuKey.value = route.name as string
  mobileMenuRef.value?.showOption(mobileMenuKey.value)
  drawerActive.value = true
}

/** Exposes 公开对象 */
defineExpose({ show })
</script>

<template>
  <NConfigProvider :theme="theme">
    <NDrawer v-model:show="drawerActive" :width="menuSetting.mainMenu.widthMobile" placement="left">
      <NDrawerContent
        :native-scrollbar="false" body-class="p-0!" body-content-class="p-0!" header-class="p-0!"
        footer-class="p-0!"
      >
        <template #header>
          <LayoutLogo flex-nowrap px-28px />
        </template>
        <template #footer>
          <div w-full>
            <NButton>Footer</NButton>
          </div>
        </template>
        <NMenu
          ref="mobileMenuRef" v-model:value="mobileMenuKey" :options="mobileMenuOptions" :indent="16"
          :icon-size="16" accordion @update:value="handleMobileMenuKeyChange"
        />
        <div v-if="!app.isDark" absolute bottom-12px w-full flex justify-center>
          <div
            :class="`i-line-md:${mainMenuInverted ? 'sunny-filled hover:text-yellow' : 'moon-filled hover:text-purple'}`"
            cursor-pointer text-18px @click="mainMenuInverted = !mainMenuInverted"
          />
        </div>
      </NDrawerContent>
    </NDrawer>
  </NConfigProvider>
</template>
