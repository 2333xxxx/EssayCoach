<p align='center'>
  <b>Admin Dashboard UI Template Based on Vue + Vite + NaiveUI + UnoCSS</b>
  <br>Create beautiful and simple admin dashboard UI projects quickly
</p>

<br>

<p align='center'>
<a href="https://showy-naive-starter.netlify.app">Online Demo</a> | <a href="#">Online Document</a>
</p>

<br>

> This is an open-source project based on the latest technology stack, aimed at providing a simple admin dashboard template.
> The project was initially created for educational purposes, featuring a clean design without complex encapsulations and advanced techniques, making it an excellent project for learning front-end technologies.
> The author is originally a backend developer who had to learn front-end development out of necessity, and hopes this project can be helpful to you.

<br>

<p align='center'>
<b>English</b> | <a href="./README.zh-CN.md">简体中文</a>
</p>

## Notice

This is merely a template project for an admin dashboard and does not implement full backend functionality. You can create a repository based on this template and implement your own admin dashboard.

⚠️ **Important Reminder: We are currently in a phase of brainstorming and code revisions. It is not advisable to use this for real-world projects.**

## Features

- 🌟 **Built with the latest and most popular front-end technologies**
- 📐 **Includes a comprehensive collection of common layout patterns**
- 🔄 **All layout patterns can be dynamically switched**
- 🧩 **Code structure is straightforward and easy to understand**
- 📝 **Fully documented with clear and comprehensive comments in both Chinese and English**
- 🎨 **Preserves the original characteristics of the component library (no theme overwriting, keeping the original style)**

## Characteristics

- ⚡️ **Vue 3** - The latest version of Vue
- 🚀 **Vite** - Super fast development build tool
- 🎨 **NaiveUI** - An interesting Vue 3 component library
- 💅 **UnoCSS** - High-performance and extremely flexible instant atomic CSS engine
- 🧹 **ESLint** - Pre-configured rule set based on [@antfu/eslint-config](https://github.com/antfu/eslint-config)

## Pre-configured

### UI Framework

- [NaiveUI](https://www.naiveui.com/) - An interesting Vue 3 component library
- [UnoCSS](https://github.com/unocss/unocss) - High-performance and extremely flexible instant atomic CSS engine

### Plugins

- [Vue Router](https://github.com/vuejs/router) - Official router for Vue.js
- [Pinia](https://pinia.vuejs.org) - Lightweight and flexible state management tool for Vue
- [unplugin-vue-components](https://github.com/antfu/unplugin-vue-components) - Automatically load components
- [unplugin-auto-import](https://github.com/antfu/unplugin-auto-import) - Automatically import Composition API, etc.
- [VueUse](https://github.com/antfu/vueuse) - Collection of useful Composition API utilities
- [Vue I18n](https://github.com/intlify/vue-i18n-next) - Internationalization support

### Coding Style

- Use the Composition API with [`<script setup>` syntax](https://v3.vuejs.org/api/sfc-script-setup.html)
- [ESLint](https://eslint.org/) configured with the pre-configured rule set from [@antfu/eslint-config](https://github.com/antfu/eslint-config)

### Development Tools

- [pnpm](https://pnpm.io/) - Fast and disk space efficient package manager
- [Vite](https://vitejs.dev/) - Next-generation front-end toolchain
- [Vue TSC](https://github.com/johnsoncodehk/vue-tsc) - TypeScript compiler for Vue
- [TypeScript](https://www.typescriptlang.org/) - Superset of JavaScript

## Try it now!

> This project requires Node version >=14.18

### GitHub Template

[Create a repository using this template](https://github.com/lileyzhao/showy-naive-starter/generate).

### Clone to local

If you prefer a cleaner git history, you can do it manually:

```bash
npx degit lileyzhao/showy-naive-starter your-vue-admin-template
cd your-vue-admin-template
pnpm i # If you haven't installed pnpm, run: npm install -g pnpm
```

## Checklist

When using this template, try to update your own information correctly according to the checklist:

- [ ] Change the author name in `LICENSE`
- [ ] Change the title in `index.html`
- [ ] Change the project name and author in `package.json`
- [ ] Change the favicon in the `public` directory
- [ ] Clean up the README and CHANGELOG and remove irrelevant information

Then, enjoy :)

## Usage

### Development

To see it in action at http://localhost:4318, just run:

```bash
pnpm i
pnpm dev
```

### Build

To build the application, run:

```bash
pnpm build
```

Then you will see the `dist` folder generated for publishing.

### Preview

After building, you can preview the build locally by running:

```bash
pnpm preview
```

### Deploy to Netlify

Go to [Netlify](https://app.netlify.com/start) and select your repository. Follow the instructions and your application will be created shortly.

## Project Structure

```plaintext
ROOT
├── .husky                   # Husky configuration files for Git hooks
├── .vscode                  # VSCode configuration folder
├── deploy                   # Deployment-related files
├── dist                     # Build output directory
├── locales                  # Internationalization resources
├── public                   # Public static assets
├── src                      # Source code directory
│   ├── api                  # API request-related code
│   ├── assets               # Static assets (images, fonts, styles, etc.)
│   ├── layouts              # Layout components
│   ├── modules              # Modularized code
│   ├── router               # Routing-related code
│   ├── shared               # Shared code and resources
│   │   ├── _builtin_views_  # Built-in view components
│   │   ├── components       # Common components
│   │   ├── constants        # Constants definitions (including enums, etc.)
│   │   ├── directives       # Custom directives
│   │   ├── hooks            # Custom hooks
│   │   ├── plugins          # Plugins
│   │   ├── settings         # Configuration and settings
│   │   ├── typings          # TypeScript type definitions
│   │   ├── utils            # Utility functions
│   ├── store                # State management
│   ├── views                # View components
│   ├── App.vue              # Root component
│   ├── main.ts              # Entry file
│   ├── permission.ts        # Permission control logic
├── .editorconfig            # Code format configuration file
├── .env                     # Environment variable configuration file
├── dockerfile               # Docker configuration file
├── index.html               # Entry HTML file
├── package.json             # Project configuration and dependency management
├── tsconfig.json            # TypeScript configuration file
├── uno.config.ts            # UnoCSS configuration file
├── vite.config.ts           # Vite configuration file
```

---
