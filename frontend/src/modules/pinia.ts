import { createPinia } from 'pinia'
import type { UserModule } from '@/shared/typings/app.d'

// Setup Pinia 安装 Pinia https://pinia.vuejs.org/
export const install: UserModule = (app) => {
  const pinia = createPinia()
  app.use(pinia)
}
