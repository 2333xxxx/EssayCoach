import { NAvatar, NIcon, NText } from 'naive-ui'

export function renderUnoIcon(iconClass: string) {
  return () => {
    return h(NIcon, null, {
      default: () => h('div', { class: iconClass.startsWith('i-') ? iconClass : `i-${iconClass}` }),
    })
  }
}

export function renderProfileHeader(options: { name?: string, intro?: string, avatar?: string }) {
  return () =>
    h('div', { style: 'display: flex; align-items: flex-start; padding: 8px 12px;' }, [
      h(NAvatar, { round: true, size: 'large', style: 'margin-right: 12px; margin-top: 6px;', src: options.avatar }),
      h('div', { style: ' width: 160px;' }, [
        h('div', null, [h(NText, { depth: 2 }, { default: () => options.name })]),
        h('div', { style: 'font-size: 12px;' }, [h(NText, { depth: 3, wrap: true }, { default: () => options.intro })]),
      ]),
    ])
}
