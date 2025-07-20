<script setup lang="ts">
import { darkTheme } from 'naive-ui'

const app = useAppStore()
const theme = computed(() => (isDark.value ? darkTheme : null))
const naiveLocale = computed(() => getNaiveLocale(app.localeSetting.locale))
</script>

<template>
  <NConfigProvider
    :theme="theme" :locale="naiveLocale.locale" :date-locale="naiveLocale.dateLocale"
    :theme-overrides="app.themeOverride" inline-theme-disabled
  >
    <NModalProvider>
      <NDialogProvider>
        <NNotificationProvider>
          <NMessageProvider>
            <RouterView />
          </NMessageProvider>
        </NNotificationProvider>
      </NDialogProvider>
    </NModalProvider>
  </NConfigProvider>
</template>
