<script setup lang="ts">
import IconComingSoon from './icons/icon-coming-soon.vue'

defineOptions({ name: 'ExceptionOffline' })

const router = useRouter()

const handleBackToHome = () => router.push({ path: '/' })
</script>

<template>
  <div class="size-full flex-center flex-col gap-12 overflow-hidden pt-3 duration-300">
    <IconComingSoon class="h-1/3 w-1/2 lg:w-1/4 md:w-1/3" />
    <div class="flex-y-center flex-col text-center">
      <p class="my-4 text-8">
        {{ $t('fallback.comingSoon') }}
      </p>
    </div>
    <NButton type="primary" @click="handleBackToHome">
      {{ $t('common.backToHome') }}
    </NButton>
  </div>
</template>

<style scoped></style>
