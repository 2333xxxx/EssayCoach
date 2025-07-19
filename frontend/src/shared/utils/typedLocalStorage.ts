/**
 * A helper class for strongly-typed localStorage operations
 * 提供 localStorage 的强类型操作类
 */
export class typedLocalStorage {
  /**
   * Stores data in localStorage
   * 存储数据到 localStorage
   *
   * @param key The key under which to store the value. 存储的键名。
   * @param value The value to store, which can be of any type. 存储的值，可以是任意类型。
   */
  static setItem<T>(key: string, value: T): void {
    try {
      const valueToStore = typeof value === 'string' ? value : JSON.stringify(value)
      localStorage.setItem(key, valueToStore)
    }
    catch (error) {
      console.error('Error saving to localStorage. 保存数据到localStorage时发生错误。', error)
    }
  }

  /**
   * Retrieves data from localStorage
   * 从 localStorage 获取数据
   *
   * @param key The key of the data to retrieve. 要获取的数据的键名。
   * @returns Returns the value retrieved from localStorage, or null if it does not exist.
   *          返回从 localStorage 中读取的值，如果值不存在，则返回 null。
   */
  static getItem<T>(key: string): T | null {
    try {
      const value = localStorage.getItem(key)
      if (value === null)
        return null

      try {
        return JSON.parse(value) as T
      }
      catch {
        return value as unknown as T
      }
    }
    catch (error) {
      console.error('Error reading from localStorage. 从localStorage读取数据时发生错误。', error)
      return null
    }
  }

  /**
   * Removes specified data from localStorage
   * 从 localStorage 中移除指定的数据
   *
   * @param key The key of the data to remove. 要移除的数据的键名。
   */
  static removeItem(key: string): void {
    try {
      localStorage.removeItem(key)
    }
    catch (error) {
      console.error('Error removing from localStorage. 从localStorage移除数据时发生错误。', error)
    }
  }

  /**
   * Removes specified data from localStorage by keys
   * 从 localStorage 中移除指定Keys集合的数据
   *
   * @param keys The keys of the data to remove. 要移除的数据的键名集合。
   */
  static removeItems(...keys: string[]): void {
    try {
      keys.forEach((key) => {
        localStorage.removeItem(key)
      })
    }
    catch (error) {
      console.error('Error removing from localStorage. 从localStorage移除数据时发生错误。', error)
    }
  }

  /**
   * Clears all data from localStorage
   * 清空 localStorage 中所有的数据
   */
  static clear(): void {
    try {
      localStorage.clear()
    }
    catch (error) {
      console.error('Error clearing localStorage. 清空localStorage时发生错误。', error)
    }
  }
}
