<script setup lang="ts">
import { DarkSchemeEnum } from '@/shared/constants/darkScheme'

defineOptions({ name: 'ProfileDrawer' })

const { t } = useI18n()
const app = useAppStore()

const icons: Record<DarkSchemeEnum, string> = {
  [DarkSchemeEnum.LIGHT]: 'i-line-md:sunny-filled',
  [DarkSchemeEnum.DARK]: 'i-line-md:moon-filled',
  [DarkSchemeEnum.AUTO]: 'i-carbon:contrast',
}

const texts: Record<DarkSchemeEnum, string> = {
  [DarkSchemeEnum.LIGHT]: 'theme.darkMode.light',
  [DarkSchemeEnum.DARK]: 'theme.darkMode.dark',
  [DarkSchemeEnum.AUTO]: 'theme.darkMode.system',
}

function handleDarkModeChange(value: DarkSchemeEnum) {
  app.setDarkScheme(value)
}

/** Main column reverse color 主栏反转颜色 */
const mainMenuInverted = computed({
  get: () => app.menuSetting.mainMenu.inverted,
  set: val => app.setMenuSetting({ mainMenu: { inverted: val } }),
})

const drawerActive = ref(false)
const show = () => drawerActive.value = true

/** Exposes 公开对象 */
defineExpose({ show })
</script>

<template>
  <NDrawer v-model:show="drawerActive" display-directive="show" :width="325">
    <NDrawerContent :title="t('theme.themeDrawerTitle')" :native-scrollbar="false" closable>
      <NDivider title-placement="left" dashed>
        {{ t('theme.darkMode.title') }}
      </NDivider>
      <div class="flex-col-stretch gap-16px">
        <div class="i-flex-center">
          <NTabs
            :key="app.darkMode" type="segment" size="small" class="relative w-214px" :value="app.darkMode"
            @update:value="handleDarkModeChange"
          >
            <NTab v-for="(_, key) in icons" :key="key" :name="key">
              <div flex items-center justify-center gap-8px>
                <div :class="`${icons[key]} text-icon-small h-23px`" />
                <span>{{ t(texts[key]) }}</span>
              </div>
            </NTab>
          </NTabs>
        </div>
        <div v-if="app.darkMode !== DarkSchemeEnum.DARK" m-y-12px flex-y-center gap-8px>
          <span>深色侧边栏</span>
          <NSwitch v-model:value="mainMenuInverted" />
        </div>
      </div>
    </NDrawerContent>
  </NDrawer>
</template>
