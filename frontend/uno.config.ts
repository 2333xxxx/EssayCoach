// unocss documentation: https://unocss.dev/guide/

import presetRemToPx from '@unocss/preset-rem-to-px'
import {
  defineConfig,
  presetAttributify,
  presetIcons,
  presetTagify,
  presetTypography,
  presetUno,
  transformerDirectives,
  transformerVariantGroup,
} from 'unocss'

export default defineConfig({
  presets: [
    // Uno默认预设，参考https://unocss.dev/presets/uno
    presetUno(),
    // 图标预设，参考https://unocss.dev/presets/icons
    presetIcons({
      collections: {
        'line-md': () => import('@iconify-json/line-md/icons.json').then(i => i.default),
        'carbon': () => import('@iconify-json/carbon/icons.json').then(i => i.default),
        'lucide': () => import('@iconify-json/lucide/icons.json').then(i => i.default),
      },
    }),
    // 属性化预设，参考https://unocss.dev/presets/attributify
    presetAttributify(),
    // 排版预设，参考https://unocss.dev/presets/typography
    presetTypography(),
    // Web字体预设，参考https://unocss.dev/presets/web-fonts
    // presetWebFonts({ fonts: { sans: 'DM Sans', serif: 'DM Serif Display', mono: 'DM Mono' } }),
    // 标签预设，可以像html标签一样使用，参考https://unocss.dev/presets/tagify
    presetTagify(),
    // 将单位rem转换为px，参考https://unocss.dev/presets/rem-to-px
    presetRemToPx({ baseFontSize: 14 }),
  ],
  theme: {
    colors: {
      'bl-gray1': '#efeff5',
      'bl-gray2': '#ffffff17',
    },
  },
  shortcuts: {
    // 定义自定义快捷方式
    'h-header': 'h-15',
    'lh-header': 'lh-15',
    'flex-center': 'flex items-center justify-center',
    'flex-right-center': 'flex items-center justify-right',
    'flex-x-center': 'flex justify-center',
    'flex-y-center': 'flex items-center',
    'inline-flex-center': 'inline-flex items-center justify-center',
    'inline-flex-right-center': 'inline-flex items-center justify-right',
    'inline-flex-x-center': 'inline-flex justify-center',
    'inline-flex-y-center': 'inline-flex items-center',
  },
  rules: [
    // 例如，添加一个自定义动画
    // ['animate-spin', { animation: 'spin 1s linear infinite' }],
  ],
  // 源代码转换器，参考https://unocss.dev/config/#transformers
  // transformerDirectives()：指令转换，参考https://unocss.dev/transformers/directives
  // transformerVariantGroup()：变体组功能，参考https://unocss.dev/transformers/variant-group
  transformers: [transformerDirectives(), transformerVariantGroup()],
  // 安全列表(始终启用的样式，不会被树摇掉) https://unocss.dev/config/#safelist
  safelist: [
    ...'prose prose-sm m-auto text-left line-clamp-2'.split(' '),
    ...'i-line-md:moon-filled i-line-md:moon-filled-loop i-line-md:sunny-filled i-line-md:sunny-filled-loop'.split(' '),
    ...'i-carbon:align-horizontal-left i-carbon:align-vertical-top'.split(' '),
    'i-carbon:information-square',
  ],
  content: {
    pipeline: {
      include: [
        // the default
        /\.(vue|svelte|[jt]sx|mdx?|astro|elm|php|phtml|html)($|\?)/,
        // 从指定文件中提取图标，参考：https://unocss.dev/guide/extracting#extracting-from-build-tools-pipeline
        'src/api-service/menuData.json',
        'src/router/index.ts',
        'src/shared/utils/menuUtil.ts',
        'src/shared/constants/tabControls.ts',
      ],
      // exclude files
      // exclude: []
    },
  },
})
