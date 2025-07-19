// vite.config documentation: https://vitejs.dev/config/

import process from 'node:process'
import { fileURLToPath, URL } from 'node:url'
import VueI18n from '@intlify/unplugin-vue-i18n/vite'
import vue from '@vitejs/plugin-vue'
import pc from 'picocolors'
import UnoCSS from 'unocss/vite'
import AutoImport from 'unplugin-auto-import/vite'
import { NaiveUiResolver } from 'unplugin-vue-components/resolvers'
import Components from 'unplugin-vue-components/vite'
import { defineConfig, loadEnv } from 'vite'
import progress from 'vite-plugin-progress'
import VueDevTools from 'vite-plugin-vue-devtools'

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const buildTime = `${new Date().toLocaleDateString()} ${new Date().toLocaleTimeString()}`
  return {
    plugins: [
      vue(),
      // https://github.com/antfu/unocss
      UnoCSS(),
      // https://github.com/intlify/bundle-tools/tree/main/packages/unplugin-vue-i18n
      VueI18n({
        runtimeOnly: true,
        compositionOnly: true,
        fullInstall: true,
        include: [fileURLToPath(new URL('./locales/**', import.meta.url))],
      }),
      AutoImport({
        dts: 'src/shared/typings/auto-import.d.ts', // 路径下自动生成文件夹存放全局指令
        imports: [
          'vue',
          'vue-router',
          'vue-i18n',
          {
            'naive-ui': ['useDialog', 'useMessage', 'useNotification', 'useLoadingBar'],
          },
        ],
        dirs: ['src/shared/hooks', 'src/store'],
      }),
      Components({
        dts: 'src/shared/typings/components.d.ts', // 路径下自动生成文件夹存放全局指令
        resolvers: [NaiveUiResolver()],
      }),
      // https://github.com/webfansplz/vite-plugin-vue-devtools
      VueDevTools(),
      progress({
        format: `${pc.green(pc.bold('Building'))} ${pc.yellowBright('[:bar]')} :percent`,
      }),
    ],
    define: {
      BUILD_TIME: JSON.stringify(buildTime),
    },
    resolve: {
      alias: {
        '~': fileURLToPath(new URL('./', import.meta.url)),
        '@': fileURLToPath(new URL('./src', import.meta.url)),
      },
      // 要忽略的后缀
      extensions: ['.ts', '.js', '.jsx', '.tsx', '.json'],
    },
    build: {
      target: 'esnext',
      // target: ["chrome89", "edge89", "firefox89", "safari15"],
      // vite默认值为500kb，可以自主修改
      chunkSizeWarningLimit: 500,
    },
    server: {
      host: true,
      port: Number(env.VITE_APP_PORT),
    },
    preview: {
      host: true,
      port: Number(env.VITE_APP_PORT) + 1,
    },
    css: {
      preprocessorOptions: {
        scss: {
          api: 'modern-compiler', // or "modern", "legacy"
        },
      },
    },
  }
})
