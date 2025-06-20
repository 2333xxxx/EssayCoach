# Celeris Web Migration

This project has been successfully migrated from a standard Vite + Vue 3 template to **Celeris Web** setup.

## What's New

### 🎨 UnoCSS Integration
- **UnoCSS** for atomic CSS with instant on-demand generation
- Presets included: Uno, Attributify, Icons, Typography, Web Fonts
- Transformers: Directives, Variant Groups
- UnoCSS Inspector available at: `http://localhost:5173/__unocss/`

### 🔧 Auto Import Features
- **unplugin-auto-import**: Automatically imports Vue APIs, Vue Router, and VueUse composables
- **unplugin-vue-components**: Automatically imports components from `src/components`
- No need to manually import common APIs like `ref`, `computed`, `RouterLink`, etc.

### 🛠️ Enhanced Developer Experience
- **@vueuse/core**: Collection of essential Vue composition utilities
- **@iconify/json**: Access to 100,000+ icons
- Dark mode support with VueUse's `useDark`
- Enhanced TypeScript support with auto-generated declaration files

## Key Files Added/Modified

### Configuration Files
- `uno.config.ts` - UnoCSS configuration with shortcuts and presets
- `vite.config.ts` - Updated with UnoCSS and auto-import plugins
- `tsconfig.app.json` - Updated to include auto-generated declaration files
- `env.d.ts` - Added type references for unplugin libraries

### Dependencies Added
```json
{
  "@iconify/json": "^2.2.271",
  "@unocss/eslint-config": "^66.2.3",
  "@vueuse/core": "^12.0.0",
  "unocss": "^66.2.3",
  "unplugin-auto-import": "^0.18.5",
  "unplugin-vue-components": "^0.27.4"
}
```

### Source Code Updates
- `src/main.ts` - Added UnoCSS import
- `src/App.vue` - Updated to showcase auto-imports and UnoCSS utilities
- `index.html` - Updated title to reflect Celeris Web

## Features Demonstrated

1. **Auto Imports**: Vue APIs and VueUse composables are automatically imported
2. **UnoCSS Utilities**: Using classes like `flex`, `items-center`, `gap-4`, and custom `btn` shortcut
3. **Dark Mode**: Toggle between light and dark themes using VueUse's `useDark`
4. **Component Auto-Import**: Components in `src/components` are automatically available

## Development Commands

```bash
# Install dependencies
pnpm install

# Start development server
pnpm dev

# Build for production
pnpm build

# Run tests
pnpm test:unit

# Run E2E tests
pnpm test:e2e:dev

# Lint code
pnpm lint
```

## UnoCSS Inspector

Visit `http://localhost:5173/__unocss/` during development to:
- Inspect generated CSS
- Search and preview utilities
- Debug CSS generation

## TypeScript Support

Auto-generated declaration files:
- `auto-imports.d.ts` - Type definitions for auto-imported APIs
- `components.d.ts` - Type definitions for auto-imported components

These files are automatically updated when you add new composables or components.

---

**Migration Complete!** 🎉

The project now uses Celeris Web's enhanced development stack while maintaining all original functionality.
