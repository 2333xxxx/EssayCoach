<script setup lang="ts">
import IconOffline from './icons/icon-offline.vue'

defineOptions({ name: 'ExceptionOffline' })

const router = useRouter()

const handleBackToHome = () => router.push({ path: '/' })
</script>

<template>
  <div class="size-full flex-center flex-col gap-12 overflow-hidden pt-3 duration-300">
    <IconOffline class="h-1/3 w-1/2 lg:w-1/4 md:w-1/3" />
    <div class="flex-y-center flex-col">
      <p class="text-8">
        {{ $t('fallback.offlineError') }}
      </p>
      <p class="my-4 text-center opacity-60">
        {{ $t('fallback.offlineErrorDesc') }}
      </p>
    </div>
    <NButton type="primary" @click="handleBackToHome">
      {{ $t('common.backToHome') }}
    </NButton>
  </div>
</template>

<style scoped></style>
