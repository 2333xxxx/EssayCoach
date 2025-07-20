/** Define size categories for various components. 定义不同组件的尺寸类别。 */
export enum SizeEnum {
  XS = 'XS',
  SM = 'SM',
  MD = 'MD',
  LG = 'LG',
  XL = 'XL',
  XXL = 'XXL',
}

/** Define screen breakpoints for responsive design. 定义响应式设计的屏幕断点。 */
export enum ScreenEnum {
  XS = 320,
  SM = 640,
  MD = 768,
  LG = 960,
  XL = 1280,
  XXL = 1536,
}

/** Map size categories to their corresponding screen breakpoints. 映射尺寸类别到其对应的屏幕断点。 */
export const SCREEN_MAP = new Map<SizeEnum, number>([
  [SizeEnum.XS, ScreenEnum.XS],
  [SizeEnum.SM, ScreenEnum.SM],
  [SizeEnum.MD, ScreenEnum.MD],
  [SizeEnum.LG, ScreenEnum.LG],
  [SizeEnum.XL, ScreenEnum.XL],
  [SizeEnum.XXL, ScreenEnum.XXL],
])
