/**
 * Deeply merges properties from a source object into a target object.
 * 深度合并源对象和目标对象的属性。
 *
 * @param source The source object. 源对象。
 * @param target The target object. 目标对象。
 * @returns Returns a new object that deeply combines properties from both source and target objects.
 *          If a property exists and is not null in the target object, the value from the target object is retained.
 *          返回一个新对象，该对象深度结合了源对象和目标对象的属性。
 *          如果目标对象中的属性已存在且非空，则保留目标对象的属性值。
 */
export function deepMergeObjects<S extends object, T extends object>(source: S, target: T): S & T {
  if (!source)
    return { ...target } as S & T
  if (!target)
    return { ...source } as S & T

  // Create a new object to avoid directly modifying the target object
  // 创建一个新对象，以避免直接修改目标对象
  const result: any = { ...target }

  Object.keys(source).forEach((key) => {
    const srcVal = source[key as keyof S]
    const tgtVal = result[key as keyof (S & T)]

    // Check if the values are objects, if so, recursively merge them
    // 检查值是否为对象，如果是，则递归合并
    if (isObject(srcVal) && isObject(tgtVal)) {
      result[key as keyof (S & T)] = deepMergeObjects(srcVal, tgtVal)
    }
    else if (!(key in target) || tgtVal === null || tgtVal === undefined) {
      // If the target object does not have the property, or the value of the property is null or undefined
      // 如果目标对象中没有该属性，或者该属性的值为空（null或undefined）
      result[key as keyof (S & T)] = srcVal
    }
  })

  return result
}

/**
 * Checks if a value is a valid object type.
 * 检查一个值是否是有效的对象类型。
 *
 * @param val The value to check. 要检查的值。
 * @returns Returns true if the value is a valid object type; otherwise, false.
 *          如果是有效的对象类型，则返回 true；否则返回 false。
 */
function isObject(val: unknown): val is Record<string, unknown> {
  return val !== null && typeof val === 'object' && !Array.isArray(val)
}
