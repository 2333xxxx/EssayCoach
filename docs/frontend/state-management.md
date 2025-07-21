# State Management

## Overview

The EssayCoach frontend uses a centralized state management approach with Pinia for Vue 3 applications.

## Store Structure

### Root Store
```typescript
// stores/root.ts
export const useRootStore = defineStore('root', {
  state: () => ({
    user: null,
    isAuthenticated: false,
    theme: 'light'
  })
})
```

### Essay Store
```typescript
// stores/essay.ts
export const useEssayStore = defineStore('essay', {
  state: () => ({
    currentEssay: null,
    essays: [],
    isLoading: false
  })
})
```

## Patterns & Best Practices

- Use composition API for store access
- Implement proper TypeScript types
- Handle async operations with proper loading states
- Use store plugins for persistence

## Development Notes

[This section will be expanded with actual implementation details]