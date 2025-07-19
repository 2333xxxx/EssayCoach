// eslint documentation: https://eslint.org/docs/latest/
// @antfu/eslint-config: https://github.com/antfu/eslint-config

import showy from '@antfu/eslint-config'

export default showy(
  {
    vue: true,
    unocss: true,
    formatters: true,
    ignores: ['dist', 'node_modules', 'public', 'tsconfig.json', 'README.md', 'README.*.md', 'LICENSE'],
  },
  {
    rules: {
      'vue/block-order': [
        'error',
        {
          order: ['script', 'template', 'style'],
        },
      ],
      'antfu/top-level-function': ['off'],
      // 'max-line-length': [
      //   'error',
      //   {
      //     code: 80, // 设置你希望的最大行长度
      //     tabWidth: 2, // 设置缩进的空格数
      //     ignoreUrls: true, // 是否忽略URL
      //     ignoreTemplateLiterals: true, // 是否忽略模板字面量
      //     ignoreStrings: true, // 是否忽略字符串
      //     ignoreRegExpLiterals: true, // 是否忽略正则表达式
      //     ignoreComments: true, // 是否忽略注释
      //     ignorePattern: '^\\s*var\\s.+=\\s*require\\s*\\(', // 可以设置忽略的模式
      //   },
      // ],
      // 'max-len': ['warn', { code: 128 }],
      'no-console': ['off'],
      'md041/first-line-heading/first-line-h1': ['off'],
    },
  },
)
