<script setup lang="ts">
import pkg from '@/../package.json'
import { useThemeVars } from 'naive-ui'
import { computed } from 'vue'

defineOptions({ name: 'About' })

const app = useAppStore()
const themeVars = useThemeVars() // Get theme variables 获取主题变量

const { t } = useI18n()

const column = computed(() => (app.isMobile ? 1 : 2))

interface PkgJson {
  name: string
  version: string
  website?: string
  dependencies: PkgVersionInfo[]
  devDependencies: PkgVersionInfo[]
}

interface PkgVersionInfo {
  name: string
  version: string
}

const { name, version, dependencies, devDependencies } = pkg

function transformVersionData(tuple: [string, string]): PkgVersionInfo {
  const [$name, $version] = tuple
  return {
    name: $name,
    version: $version,
  }
}

const pkgJson: PkgJson = {
  name,
  version,
  dependencies: Object.entries(dependencies).map(item => transformVersionData(item)),
  devDependencies: Object.entries(devDependencies).map(item => transformVersionData(item)),
}

const latestBuildTime = BUILD_TIME
</script>

<template>
  <NCard content-class="!p-8px" :bordered="false">
    <NSpace vertical :size="14">
      <NCard :title="t('page.about.title')" :bordered="false" size="small" segmented class="card-wrapper">
        <p>{{ t('page.about.introduction') }}</p>
      </NCard>
      <NCard :title="t('page.about.projectInfo.title')" :bordered="false" size="small" segmented class="card-wrapper">
        <NDescriptions label-placement="left" bordered size="small" :column="column">
          <NDescriptionsItem :label="t('page.about.projectInfo.version')">
            <NTag type="primary">
              {{ pkgJson.version }}
            </NTag>
          </NDescriptionsItem>
          <NDescriptionsItem :label="t('page.about.projectInfo.latestBuildTime')">
            <NTag type="primary">
              {{ latestBuildTime }}
            </NTag>
          </NDescriptionsItem>
          <NDescriptionsItem :label="t('page.about.projectInfo.githubLink')">
            <a
              :style="`color:${themeVars.primaryColor}`" :href="pkg.homepage" target="_blank"
              rel="noopener noreferrer"
            >
              {{ t('page.about.projectInfo.githubLink') }}
            </a>
          </NDescriptionsItem>
          <NDescriptionsItem :label="t('page.about.projectInfo.previewLink')">
            <a :style="`color:${themeVars.primaryColor}`" :href="pkg.website" target="_blank" rel="noopener noreferrer">
              {{ t('page.about.projectInfo.previewLink') }}
            </a>
          </NDescriptionsItem>
        </NDescriptions>
      </NCard>
      <NCard :title="t('page.about.prdDep')" :bordered="false" size="small" segmented class="card-wrapper">
        <NDescriptions label-placement="left" bordered size="small" :column="column">
          <NDescriptionsItem v-for="item in pkgJson.dependencies" :key="item.name" :label="item.name">
            {{ item.version }}
          </NDescriptionsItem>
        </NDescriptions>
      </NCard>
      <NCard :title="t('page.about.devDep')" :bordered="false" size="small" segmented class="card-wrapper">
        <NDescriptions label-placement="left" bordered size="small" :column="column">
          <NDescriptionsItem v-for="item in pkgJson.devDependencies" :key="item.name" :label="item.name">
            {{ item.version }}
          </NDescriptionsItem>
        </NDescriptions>
      </NCard>
    </NSpace>
  </NCard>
</template>

<style scoped></style>
