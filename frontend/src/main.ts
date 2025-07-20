import type { UserModule } from './shared/typings/app.d'
import pc from 'picocolors'
import { createApp } from 'vue'
import App from './App.vue'
import { router, setupRouter } from './router'

import '@unocss/reset/tailwind.css'
import '@/assets/styles/main.scss'
import 'virtual:uno.css'

async function bootstrap() {
  console.log(pc.bgGreen(pc.red(' DevTeam ')) + pc.bgMagenta(pc.white(' Showy ')))

  // Create a new Vue application instance
  // 创建一个新的 Vue 应用实例
  const app = createApp(App)

  // Install all modules from the `modules/` directory
  // 安装目录`modules/`下的所有模块
  Object.values(import.meta.glob<{ install: UserModule }>('./modules/*.ts', { eager: true })).forEach(
    async i => await i.install?.(app),
  )

  // Set up the router 挂载路由
  await setupRouter(app)

  // Wait for the router to be ready before mounting the app
  // 路由准备就绪后挂载 APP 实例
  // https://router.vuejs.org/api/interfaces/Router.html#isReady
  await router.isReady()

  // Prevent external styles from overriding naive-ui component styles
  // 防止外部样式覆盖naive-ui组件样式
  // https://www.naiveui.com/zh-CN/os-theme/docs/style-conflict
  const meta = document.createElement('meta')
  meta.name = 'naive-ui-style'
  document.head.appendChild(meta)

  // Remove the loading effect after the app is mounted
  // 应用挂载后移除加载效果
  app.mount('#app').$nextTick(() => {
    const loadingElement = document.getElementById('loading')
    if (loadingElement) {
      loadingElement.style.display = 'none'
    }
  })
}

// Setup App 启动应用
bootstrap()
