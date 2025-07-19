<script setup lang="ts">
import SyIconButton from '@/shared/components/SyIconButton.vue'
import { useThemeVars } from 'naive-ui'
import { MAIN_MENU_KEY, SUB_MENU_KEY, UPDATE_MAIN_MENU_KEY, UPDATE_SUB_MENU_KEY } from '~/src/shared/constants/symbols'
import { TAB_MENUS } from '~/src/shared/constants/tabControls'
import { findRootRouteName, getFullRoutes } from '~/src/shared/utils/routeUtil'

const { t } = useI18n()
const router = useRouter()
const fullRoutes = getFullRoutes()
const themeVars = useThemeVars()

const tabsStore = useTabsStore()
const tabList = computed(() => tabsStore.tabs)

// Inject the menu object 注入菜单对象
const mainMenuKey = inject(MAIN_MENU_KEY)!
const subMenuKey = inject(SUB_MENU_KEY)!
const updateMainMenuKey = inject(UPDATE_MAIN_MENU_KEY)!
const updateSubMenuKey = inject(UPDATE_SUB_MENU_KEY)!

const handleTabChange = (tabName: string) => {
  router.push(tabName)
  // 从 fullRoutes 中查找 tabName 对应的路由信息
  const menuKey = fullRoutes.find(r => r.path === tabName)?.name as string
  if (menuKey) {
    nextTick(() => {
      if (subMenuKey.value !== menuKey)
        updateSubMenuKey(menuKey)
      const rootKey = findRootRouteName(menuKey, fullRoutes) ?? menuKey
      if (mainMenuKey.value !== rootKey)
        updateMainMenuKey(rootKey)
    })
  }
}

async function handleTabClose(tabName: string) {
  tabsStore.removeTab(tabName)
  router.push(tabsStore.activeTab)
}

const contextMenuState = reactive({ show: false, x: 0, y: 0, key: '' })
function handleTabContextMenu(e: MouseEvent, key: string) {
  if (key !== tabsStore.activeTab)
    return
  e.preventDefault()
  contextMenuState.show = false
  nextTick(() => {
    contextMenuState.show = true
    contextMenuState.x = e.clientX
    contextMenuState.y = e.clientY
    contextMenuState.key = key
  })
}

function handleMenuSelect(menuKey: string | number, tabKey?: string | undefined) {
  contextMenuState.show = false
  switch (menuKey) {
    case 'closeTab':
      handleTabClose(tabKey ?? tabsStore.activeTab)
      break
    case 'pinTab':
      break
    case 'reload':
      break
    case 'openInNewWindow':
      break
    case 'closeOtherTabs':
      tabsStore.removeOtherTabs(tabKey ?? tabsStore.activeTab)
      break
    case 'closeRightTabs':
      tabsStore.removeRightTabs(tabKey ?? tabsStore.activeTab)
      break
    case 'closeAllTabs':
      tabsStore.removeOtherTabs(tabKey ?? tabsStore.activeTab)
      break
  }
}

function onClickoutside() {
  contextMenuState.show = false
}
</script>

<template>
  <NLayoutHeader class="tab-container">
    <div :style="`--border-color:${themeVars.dividerColor}`">
      <NTabs
        v-model:value="tabsStore.activeTab" type="card" animated closable size="small"
        :on-update:value="handleTabChange" @close="handleTabClose"
      >
        <NTab
          v-for="tb in tabList" :key="tb.name" :name="tb.fullPath" style="mt-3px"
          @contextmenu="(e) => handleTabContextMenu(e, tb.fullPath as string)"
        >
          {{ t(tb.meta.title as string) || tb.name }}
        </NTab>
      </NTabs>
    </div>
    <div>
      <NDropdown :options="TAB_MENUS" trigger="click" @select="(key) => handleMenuSelect(key)">
        <SyIconButton icon="i-carbon:chevron-down" button />
      </NDropdown>
      <SyIconButton icon="i-lucide:fullscreen" button />
      <NDropdown
        trigger="manual" :options="TAB_MENUS" :show="contextMenuState.show" :x="contextMenuState.x"
        :y="contextMenuState.y" :on-clickoutside="onClickoutside"
        @select="(key) => handleMenuSelect(key, contextMenuState.key)"
      />
    </div>
  </NLayoutHeader>
</template>

<style scoped lang="scss">
.tab-container {
  --uno: flex flex-nowrap;

  > :not(:last-child) {
    --uno: flex-grow;
    width: calc(100% - 85px);
  }

  > :last-child {
    --uno: basis-auto;
    width: 85px;
  }

  .sy-icon-button {
    display: inline-block;
    height: 100%;
    border-radius: 0;
    border-width: 0 0 1px 1px;
  }

  :deep(.n-tabs) {
    width: calc(100% - 3px);

    .n-tabs-tab.n-tabs-tab--closable {
      padding: 7px 16px !important;
      margin-top: 3px;
      min-width: 80px;

      button {
        display: none !important;
      }

      .n-tabs-tab__label {
        user-select: none;
      }

      &.n-tabs-tab--active {
        padding-right: 8px !important;
        border-bottom-color: var(--border-color) !important;

        button {
          display: unset !important;
        }
      }
    }
  }
}
</style>
