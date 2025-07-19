<script setup lang="ts">
import { useThemeVars } from 'naive-ui'

defineOptions({ name: 'SyIconButton' })

const props = defineProps({
  icon: String,
  size: [Number, String],
  button: Boolean,
  text: String,
  vertical: Boolean,
  class: [String, Array, Object],
  style: [String, Object],
})

const themeVars = useThemeVars()
const colorVars = computed(() => {
  return { '--primary-color': themeVars.value.primaryColor, '--text-color': themeVars.value.textColor2 }
})

const sizeVal = computed(() => typeof props.size === 'number' ? `${props.size}px` : props.size ?? '1.3em')

const customClass = computed(() => props.class)
const customStyle = computed(() => `${props.style} ; border-color: ${themeVars.value.dividerColor}`)
</script>

<template>
  <div class="sy-icon-button" :class="[{ 'sy-is-button': button }, customClass]" :style="[customStyle, colorVars]">
    <div class="sy-icon-container" :class="[{ 'sy-vertical': vertical }]" flex-y-center>
      <div :class="icon" :style="{ fontSize: sizeVal }" />
      <span v-if="text" :style="{ height: sizeVal, lineHeight: sizeVal }">{{ text }}</span>
    </div>
  </div>
</template>

<style scoped lang="scss">
.sy-icon-button {
  border-radius: 2px;
  cursor: pointer;
  padding: 9px 11px;
  color: var(--text-color);

  &:hover {
    color: var(--primary-color);
  }

  &.sy-is-button:hover {
    background-color: rgba(46, 51, 56, 0.09);
    color: var(--text-color);
  }

  .sy-icon-container {
    display: flex;
    align-items: center;

    &.sy-vertical {
      flex-direction: column;
      justify-content: center;

      span {
        margin: 8px 0 0 0;
      }
    }

    span {
      margin-left: 8px;
    }
  }
}

.dark {
  .sy-icon-button.sy-is-button:hover {
    background-color: rgba(255, 255, 255, 0.12);
  }
}
</style>
