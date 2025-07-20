// prettierrc documentation: https://prettier.io/docs/en/

/** @type {import("prettier").Config} */
export default {
  // 每行代码的长度限制
  printWidth: 128,
  // 指定一个制表符等于的空格数
  tabWidth: 2,
  // 使用制表符缩进，而不是空格缩进
  useTabs: false,
  // 在所有代码语句的末尾添加分号
  semi: false,
  // 使用单引号而不是双引号
  singleQuote: true,
  // 指定对象字面量中的属性名引号添加方式。可选值"<as-needed|consistent|preserve>"
  quoteProps: 'as-needed',
  // JSX 中使用单引号而不是双引号
  jsxSingleQuote: false,
  // 指定添加尾后逗号的方式。可选值"<none|es5|all>"
  trailingComma: 'es5',
  // 在对象字面量的花括号内侧使用空格作为间隔。
  bracketSpacing: true,
  // 会把多行的 HTML (包括 HTML、JSX、Vue 和 Angular) 元素的 > 放在最后一个属性的末尾，
  // 而不是另起一行（自闭合标签不受该选项控制）。
  bracketSameLine: false,
  // 箭头函数仅有一个参数时，参数是否添加括号。always：(x) => x \ avoid：x => x
  arrowParens: 'always',
  // 这两个选项可用于格式化以给定字符偏移量（分别包括和不包括）开始和结束的代码
  rangeStart: 0,
  rangeEnd: Number.POSITIVE_INFINITY,
  // 是否仅格式化在文件头部添加 @prettier 标记的文件
  requirePragma: false,
  // 是否在文件头部插入特定的 @format 标记以表示该文件已被 Prettier 格式化过
  insertPragma: false,
  // 用于Markdown的文本换行 always\never\preserve
  proseWrap: 'preserve',
  // 指定 HTML 文件的空白字符敏感度。 可选值"css\strict\ignore"
  htmlWhitespaceSensitivity: 'ignore',
  // 缩进 Vue SFC 文件中的 <script> 和 <style> 标签。
  vueIndentScriptAndStyle: false,
  // 换行符使用 lf 结尾是 可选值"<auto|lf|crlf|cr>"
  endOfLine: 'lf',
}
