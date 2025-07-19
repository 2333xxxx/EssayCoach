<script setup lang="ts">
import FloatingGhost from '~/src/shared/components/cartoon/FloatingGhost.vue'
import Jigglypuff from '~/src/shared/components/cartoon/Jigglypuff.vue'

defineOptions({ name: 'Welcome' })

const { t } = useI18n()
const app = useAppStore()

const currentTime = ref('00:00:00')

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString()
}

onMounted(() => {
  updateTime()
  setInterval(updateTime, 1000)
})
</script>

<template>
  <NCard content-class="!p-0" :bordered="false">
    <div flex flex-col items-center justify-center gap-y-4 pt-4>
      <div
        :class="`i-line-md:${app.isDark ? 'moon-filled-loop text-purple' : 'sunny-filled-loop text-yellow'}`"
        text-24
      />
      <div class="time-display">
        {{ currentTime }}
      </div>
      <div text-6>
        {{ app.isDark ? t('welcome.night') : t('welcome.morning') }}
      </div>
      <Jigglypuff v-if="!app.isDark" style="margin:80px 0;" />
      <FloatingGhost v-else style="margin:80px 0;" />
    </div>
    <div class="mx-16 my-30 h-60vh flex flex-col items-center justify-end text-4">
      <span class="quota">
        {{ t('intro') }}
      </span>
    </div>
  </NCard>
</template>

<style scoped lang="scss">
@use '../assets/styles/_fonts.scss';

.time-display {
  font-family: 'DSEG7ModernMini', sans-serif;
  font-size: 2rem;
  font-weight: bold;
}

.quota {
  text-align: justify;
  border-bottom: 5px solid #ccc;
  padding-bottom: 10px;
}

.dark .quota {
  border-bottom: 5px solid #333;
}
</style>
