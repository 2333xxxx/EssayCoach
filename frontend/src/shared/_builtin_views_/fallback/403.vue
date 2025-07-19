<script setup lang="ts">
import Icon403 from './icons/icon-403.vue'

defineOptions({ name: 'Exception403' })

const router = useRouter()

const handleBackToHome = () => router.push({ path: '/' })
</script>

<template>
  <div class="size-full flex-center flex-col gap-4 overflow-hidden pt-3 duration-300">
    <Icon403 class="h-1/3 w-1/2 lg:w-1/4 md:w-1/3" />
    <div class="flex-y-center flex-col text-center">
      <p class="text-8">
        {{ $t('fallback.forbidden') }}
      </p>
      <p class="my-4 opacity-60">
        {{ $t('fallback.forbiddenDesc') }}
      </p>
    </div>
    <NButton type="primary" @click="handleBackToHome">
      {{ $t('common.backToHome') }}
    </NButton>
  </div>
</template>

<style scoped></style>
