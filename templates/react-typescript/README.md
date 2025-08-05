# React TypeScript Project Template

**Modern React Application with TypeScript Best Practices**

This template provides a complete setup for developing modern React applications with TypeScript, following industry best practices and latest tooling.

## 🎯 **What This Template Provides**

### **Modern React Stack**
- **Vite** - Fast build tool and development server
- **TypeScript** - Type safety and enhanced developer experience
- **React 18** - Latest React with concurrent features
- **React Router** - Client-side routing
- **React Query** - Server state management

### **Development Tools Integration**
- **Cursor MCP Configuration** - Memory, Component analysis, Bundle optimization
- **VSCode Settings** - React development, TypeScript, debugging
- **ESLint & Prettier** - Code quality and formatting
- **Husky & lint-staged** - Git hooks for quality gates

### **Testing & Quality**
- **Vitest** - Fast unit testing framework
- **React Testing Library** - Component testing utilities
- **Playwright** - End-to-end testing
- **Storybook** - Component documentation and testing

### **UI & Styling**
- **Tailwind CSS** - Utility-first CSS framework
- **Headless UI** - Unstyled, accessible UI components
- **Lucide React** - Modern icon library
- **CSS Modules** - Scoped styling support

## 📁 **Template Structure**

```
react-typescript-project/
├── src/
│   ├── components/
│   │   ├── ui/                       # Reusable UI components
│   │   ├── layout/                   # Layout components
│   │   └── features/                 # Feature-specific components
│   ├── pages/
│   │   ├── Home.tsx                  # Page components
│   │   ├── About.tsx
│   │   └── NotFound.tsx
│   ├── hooks/
│   │   ├── useApi.ts                 # Custom React hooks
│   │   ├── useLocalStorage.ts
│   │   └── useDebounce.ts
│   ├── utils/
│   │   ├── api.ts                    # API utilities
│   │   ├── constants.ts              # Application constants
│   │   └── helpers.ts                # Helper functions
│   ├── types/
│   │   ├── api.ts                    # API type definitions
│   │   ├── components.ts             # Component prop types
│   │   └── global.ts                 # Global type definitions
│   ├── styles/
│   │   ├── globals.css               # Global styles
│   │   ├── components.css            # Component styles
│   │   └── tailwind.css              # Tailwind imports
│   ├── assets/
│   │   ├── images/                   # Image assets
│   │   ├── icons/                    # Icon assets
│   │   └── fonts/                    # Font files
│   ├── config/
│   │   ├── env.ts                    # Environment configuration
│   │   └── constants.ts              # Configuration constants
│   ├── App.tsx                       # Main application component
│   ├── main.tsx                      # Application entry point
│   └── vite-env.d.ts                 # Vite type definitions
├── public/
│   ├── favicon.ico                   # Application favicon
│   ├── manifest.json                 # PWA manifest
│   └── robots.txt                    # SEO robots file
├── tests/
│   ├── components/                   # Component tests
│   ├── hooks/                        # Hook tests
│   ├── utils/                        # Utility tests
│   ├── e2e/                          # End-to-end tests
│   └── setup.ts                      # Test setup configuration
├── stories/                          # Storybook stories
│   ├── components/
│   └── pages/
├── docs/
│   ├── ARCHITECTURE.md               # Application architecture
│   ├── CONTRIBUTING.md               # Contribution guidelines
│   └── DEPLOYMENT.md                 # Deployment instructions
├── .storybook/                       # Storybook configuration
├── .cursor/
│   ├── mcp.json                      # MCP server configuration
│   └── rules/                        # React-specific Cursor rules
├── .vscode/
│   ├── settings.json                 # VSCode configuration
│   ├── extensions.json               # Recommended extensions
│   └── launch.json                   # Debug configuration
├── vite.config.ts                    # Vite configuration
├── tailwind.config.js                # Tailwind CSS configuration
├── tsconfig.json                     # TypeScript configuration
├── package.json                      # Dependencies and scripts
├── .eslintrc.js                      # ESLint configuration
├── .prettierrc                       # Prettier configuration
├── .env.example                      # Environment variables
└── README.md                         # Project documentation
```

## 🚀 **Quick Start**

### **1. Initialize React TypeScript Project**
```bash
# From dev-project-init repository
./scripts/init-project.sh my-react-app /path/to/my-react-app --template react-typescript
```

### **2. Install Dependencies**
```bash
cd /path/to/my-react-app
npm install
```

### **3. Start Development Server**
```bash
npm run dev
```

### **4. Access Development Tools**
- **Application**: http://localhost:3000
- **Storybook**: http://localhost:6006 (npm run storybook)
- **Bundle Analyzer**: npm run analyze

## 🔧 **Configuration Details**

### **MCP Servers Included**
- **neo4j-memory** (Port 9688) - Development memory
- **component-analyzer** (Port 9511) - Component analysis and optimization
- **state-manager** (Port 9512) - State management assistance
- **bundle-optimizer** (Port 9513) - Bundle analysis and optimization

### **Development Scripts**
```json
{
  "dev": "vite",
  "build": "tsc && vite build",
  "preview": "vite preview",
  "test": "vitest",
  "test:e2e": "playwright test",
  "test:coverage": "vitest --coverage",
  "lint": "eslint src --ext ts,tsx --report-unused-disable-directives --max-warnings 0",
  "lint:fix": "eslint src --ext ts,tsx --fix",
  "format": "prettier --write src/**/*.{ts,tsx,css,md}",
  "storybook": "storybook dev -p 6006",
  "build-storybook": "storybook build",
  "analyze": "npm run build && npx vite-bundle-analyzer dist"
}
```

### **IDE Extensions**
- **ES7+ React/Redux/React-Native snippets** - Code snippets
- **TypeScript Importer** - Auto import management
- **Tailwind CSS IntelliSense** - CSS class suggestions
- **Auto Rename Tag** - HTML/JSX tag synchronization
- **Bracket Pair Colorizer** - Bracket visualization
- **GitLens** - Git integration enhancement

## 📚 **Best Practices Included**

### **Code Organization**
- **Feature-based folder structure** - Logical component grouping
- **Barrel exports** - Clean import/export patterns
- **Separation of concerns** - UI, logic, and data separation
- **Type-first development** - TypeScript-first approach

### **Performance Optimization**
- **Code splitting** - Route-based and component-based
- **Lazy loading** - Dynamic imports for performance
- **Bundle optimization** - Tree shaking and minification
- **Image optimization** - WebP support and lazy loading

### **Testing Strategy**
- **Unit tests** - Component and utility testing
- **Integration tests** - Feature workflow testing
- **E2E tests** - User journey validation
- **Visual regression** - Storybook visual testing

### **Accessibility**
- **ARIA labels** - Screen reader support
- **Keyboard navigation** - Full keyboard accessibility
- **Color contrast** - WCAG compliant color schemes
- **Semantic HTML** - Proper HTML structure

## 🛠️ **Customization Options**

### **State Management**
- **React Query** - Server state (included)
- **Zustand** - Client state (lightweight alternative)
- **Redux Toolkit** - Complex state management
- **Jotai** - Atomic state management

### **UI Libraries**
- **Tailwind CSS** - Utility-first (included)
- **Styled Components** - CSS-in-JS styling
- **Emotion** - Performant CSS-in-JS
- **Chakra UI** - Component library integration

### **Build Tools**
- **Vite** - Fast development (included)
- **Webpack** - Advanced configuration
- **Rollup** - Library bundling
- **esbuild** - Ultra-fast building

### **Deployment Targets**
- **Vercel** - Serverless deployment
- **Netlify** - JAMstack deployment
- **AWS S3/CloudFront** - CDN deployment
- **Docker** - Containerized deployment

## 🧪 **Testing Examples**

### **Component Test**
```typescript
import { render, screen } from '@testing-library/react'
import { Button } from '../Button'

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument()
  })
})
```

### **Hook Test**
```typescript
import { renderHook } from '@testing-library/react'
import { useLocalStorage } from '../useLocalStorage'

describe('useLocalStorage', () => {
  it('returns initial value', () => {
    const { result } = renderHook(() => useLocalStorage('key', 'initial'))
    expect(result.current[0]).toBe('initial')
  })
})
```

---

**This template provides a production-ready React TypeScript application with modern tooling, comprehensive testing, and development best practices.**