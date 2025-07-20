<script setup lang="ts">
defineOptions({ name: 'LayoutContent' })
</script>

<template>
  <div flex flex-grow flex-col p-12px>
    <RouterView v-slot="{ Component, route: r }">
      <Transition name="slide-fade" mode="out-in" :appear="true">
        <KeepAlive :max="25">
          <component :is="Component" :key="r.fullPath" class="flex-grow transition-300" />
        </KeepAlive>
      </Transition>
    </RouterView>
  </div>
</template>

<style scoped>
.slide-fade-enter-active,
.slide-fade-leave-active {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
}

.slide-fade-enter-from {
  opacity: 0;
  transform: translateX(-30px);
}

.slide-fade-leave-to {
  opacity: 0;
  transform: translateX(30px);
}
</style>
