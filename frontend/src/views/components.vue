<script setup lang="ts">
import type { Type } from 'naive-ui/es/button/src/interface'

defineOptions({ name: 'Components' })

const currentTime = ref('00:00:00')

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleTimeString()
}

const buttonModels = [{}, { secondary: true }, { tertiary: true }, { dashed: true }, { disabled: true }]
const buttonTypes: Type[] = ['default', 'primary', 'info', 'success', 'warning', 'error']
const buttonTypesShuffled: Type[][] = []
for (let i = 0; i < buttonModels.length; i++) {
  buttonTypesShuffled.push(buttonTypes.slice().sort(() => 0.5 - Math.random()).slice(0, 4))
}

onMounted(() => {
  updateTime()
  setInterval(updateTime, 1000)
})
</script>

<template>
  <div flex flex-col>
    <NCard :bordered="false">
      <div flex flex-col items-center justify-center gap-y-4 pt-4>
        <NSpace>
          <NDatePicker type="date" w-48 />
          <NTimePicker w-48 />
        </NSpace>
        <NSpace v-for="(bm, bmi) in buttonModels" :key="bmi">
          <NButton v-for="(bt, bti) in buttonTypesShuffled[bmi]" :key="bti" :type="bt" class="w-23!" v-bind="bm">
            {{ bt }}
          </NButton>
        </NSpace>
      </div>
    </NCard>
  </div>
</template>

<style scoped lang="scss">
@use '../assets/styles/_fonts.scss';

.time-display {
  font-family: 'DSEG7ModernMini', sans-serif;
  font-size: 2rem;
  font-weight: bold;
}
</style>
