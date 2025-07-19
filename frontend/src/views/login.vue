<script setup lang="ts">
import SyIconButton from '@/shared/components/SyIconButton.vue'

defineOptions({ name: 'Login' })

const { t } = useI18n()
const router = useRouter()
const app = useAppStore()

const model = ref({ account: 'admin', password: 'admin' })

const onLogin = () => router.push('/')
</script>

<template>
  <div mx-auto mt-30 w-380px>
    <NCard :title="t('login.title')">
      <NForm :model="model">
        <NFormItem path="account" label="账号">
          <NInput v-model="model.account" placeholder="请输入账号" @keydown.enter.prevent />
        </NFormItem>
        <NFormItem path="password" label="密码">
          <NInput v-model="model.password" type="password" placeholder="请输入密码" @keydown.enter.prevent />
        </NFormItem>
        <div flex items-center justify-between>
          <div flex-right-center gap-x-5>
            <SyIconButton
              :icon="`i-line-md:${app.isDark ? 'sunny-filled' : 'moon-filled'}`"
              hover-class-dark="text-yellow" hover-class-light="text-purple" @click="app.toggleDarkMode"
            />
            <SyIconButton v-if="app.localeSetting.showButton" i-carbon-language @click="app.toggleLanguage" />
          </div>
          <NButton type="primary" style="width: 120px" @click="onLogin">
            登 录
          </NButton>
        </div>
      </NForm>
    </NCard>
  </div>
</template>
