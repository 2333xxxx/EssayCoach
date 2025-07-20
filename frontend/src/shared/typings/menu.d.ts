/**
 * @enum Enum for Menu Buttons 菜单按钮的枚举
 */
export enum MenuButtonEnum {
  /**
   * theme settings drawer button
   * 主题设置抽屉的按钮
   */
  ThemeDrawer = 'ThemeDrawer',
  /**
   * menu position button
   * 菜单位置按钮(切换顶栏/侧栏)
   */
  MenuPosition = 'MenuPosition',
  /**
   * main-menu status toggle button
   * 主菜单状态切换按钮
   */
  MainMenuStatus = 'MainMenuStatus',
  /**
   * sub-menu status toggle button
   * 副菜单状态切换按钮(副菜单收缩展开)
   */
  SubMenuStatus = 'SubMenuStatus',
  /**
   * theme schema toggle button (dark/light)
   * 主题模式切换按钮(深色/浅色)
   */
  ThemeMode = 'ThemeMode',
}

/**
 * @enum Enum Form Menu Position Type 菜单位置的枚举
 */
export enum MenuPositionEnum {
  /** Sidebar 侧栏模式 */
  SIDEBAR = 'Sidebar',
  /** TopBar 顶栏 */
  TOP_BAR = 'TopBar',
}

/**
 * @enum Menu Status Pedometer Enumeration 菜单状态枚举
 */
export enum MenuStateEnum {
  /** collMainMenu:true showIconLabel:true */
  NORMAL = 1,
  /** collMainMenu:true showIconLabel:false */
  ICON_LABEL = 2,
  /** collMainMenu:false showIconLabel:false */
  ONLY_ICON = 3,
}

/**
 * @interface Menu Settings 菜单设置
 */
export interface MenuSetting {
  /** Displayed menu button set 显示的菜单按钮集合 */
  buttons: MenuButtonEnum[]

  /**
   * Menu position, optional Sidebar sidebar | TopBar top bar, if TopBar top bar, all other configurations will be useless
   * 菜单位置，可选 Sidebar侧栏 | TopBar顶栏，如果为 TopBar顶栏，其他所有配置将无用
   */
  menuPosition: MenuPositionEnum

  /** Top-menu settings 顶栏菜单设置 */
  topMenu: {
    /** Show the sub-menu? 是否显示副栏菜单 */
    showSubMenu: boolean
  }

  /** Main-menu settings 主栏菜单设置 */
  mainMenu: {
    /** Collapse the main menu? 是否收缩主栏菜单 */
    collapsed: boolean
    /** Main menu width 主栏菜单宽度 */
    width: number
    /** Main menu width (collapsed) 主栏菜单宽度(收缩时) */
    widthColl: number
    /** Main menu width (when hiding the sub-menu menu) 主栏菜单宽度(当隐藏副栏菜单时) */
    widthSingle: number
    /** Main menu width (when the mobile phone is used) 主栏菜单宽度(当手机端时) */
    widthMobile: number
    /** Reverse the main menu color? 是否反转主栏菜单颜色 */
    inverted: boolean
    /** Show the text under icons? (effective when the main menu is collapsed) 是否显示图标下方的文字(当收缩主栏菜单时有效) */
    showLabel: boolean
  }

  /** Sub-menu settings 副栏菜单设置 */
  subMenu: {
    /** Collapse the sub-menu? 是否收缩副栏菜单 */
    collapsed: boolean
    /** Sub-menu width 副栏菜单宽度 */
    width: number
  }

  /**
   * Menu Status (Used to record the status of the menu, please try not to change manually)
   * 菜单状态(用于记录菜单状态，尽量不要手动变更)
   *
   * @description When modifying the default value, please ensure it is set according to the following correspondence to avoid incorrect menu status transitions.
   *              修改默认值时，请确保按照以下对应关系设置，避免菜单状态转换错误。
   *
   *              Step 1 (NORMAL) :     collMainMenu:true showIconLabel:true
   *              Step 2 (ICON_LABEL) : collMainMenu:true showIconLabel:false
   *              Step 3 (ONLY_ICON):   collMainMenu:false showIconLabel:false
   */
  menuState?: MenuStateEnum
}
