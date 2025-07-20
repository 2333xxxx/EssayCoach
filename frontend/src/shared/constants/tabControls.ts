import { renderUnoIcon } from '~/src/shared/utils/componentUtil'

export const TAB_CONTROLS = [
  { label: '关闭', key: 'closeTab', icon: 'i-lucide:x' },
  { label: '固定', key: 'pinTab', icon: 'i-lucide:pin' },
  { label: '重新加载', key: 'reload', icon: 'i-lucide:rotate-cw' },
  { label: '在新窗口打开', key: 'openInNewWindow', icon: 'i-lucide:external-link' },
  { type: 'divider', key: 'divider1' },
  { label: '关闭其他', key: 'closeOtherTabs', icon: 'i-lucide:badge-x' },
  { label: '关闭右侧标签', key: 'closeRightTabs', icon: 'i-lucide:list-x rotate-180' },
  { label: '全部关闭', key: 'closeAllTabs', icon: 'i-lucide:copy-x' },
]

export const TAB_MENUS = TAB_CONTROLS.map(item => ({ ...item, icon: item.icon ? renderUnoIcon(item.icon) : undefined }))
