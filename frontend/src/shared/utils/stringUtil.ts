/**
 * Removes white space characters from a string
 * 清除字符串中的空白字符
 *
 * @param value - The input string, which can be null
 *                输入的字符串，可以为null
 * @returns The string after removing white space characters, or null if input is null
 *          清除空白字符后的字符串，如果输入为null则返回null
 */
export function clearWhiteSpace(value: string | null): string | null {
  // Return the input value if it is null
  // 如果输入值为null，则直接返回
  if (value === null)
    return value

  let result = ''

  for (const c of value) {
    // If the character is not a white space, add it to the result string
    // 如果字符不是空白字符，则将其添加到结果字符串中
    if (!/\s/.test(c))
      result += c
  }

  return result
}
