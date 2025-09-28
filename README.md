# Rails Engine Stimulus Integration Examples

This repository demonstrates **two different approaches** for integrating Stimulus JavaScript controllers in Rails engines, each with distinct trade-offs and use cases.

## 🚀 Quick Overview

| Engine | Strategy | Best For |
|--------|----------|----------|
| **[blogh_isolate](./blogh_isolate/)** | Isolated Setup | Independent modules, microservices, reusable components |
| **[blogh_main_app_layout](./blogh_main_app_layout/)** | Main App Integration | Feature extensions, admin panels, content management |

## 📁 Repository Structure

```
engine_stimulus/
├── blogh_isolate/           # 🔒 Isolated Stimulus engine
│   ├── app/javascript/blogh/    # Engine-specific JS structure
│   ├── config/importmap.rb      # Custom importmap configuration
│   └── app/helpers/             # Custom importmap helper
│
├── blogh_main_app_layout/   # 🏠 Main app integrated engine  
│   ├── app/javascript/controllers/blogh/  # Main app JS structure
│   └── app/views/               # Uses main app layout
│
└── README.md               # This file
```

## 🔒 Approach 1: Isolated Engine (`blogh_isolate`)

### What It Is
A **completely self-contained** Rails engine with its own Stimulus setup, importmap, and JavaScript bundle.

### Key Features
- ✅ Own importmap configuration
- ✅ Custom `blogh_importmap_tags` helper
- ✅ Independent asset compilation
- ✅ Engine-specific layout
- ✅ No main app JavaScript dependencies

### JavaScript Architecture
```javascript
// Engine creates its own Stimulus application
import { Application } from "@hotwired/stimulus"
const application = Application.start()

// Controllers loaded from engine namespace
eagerLoadControllersFrom("controllers", application)
```

### When to Choose
- 🎯 **Microservice Architecture**: Engine can be deployed independently
- 🎯 **Reusable Components**: Same engine used across multiple apps
- 🎯 **Version Independence**: Engine JS updates don't affect main app
- 🎯 **Team Isolation**: Different teams work on engine vs main app
- 🎯 **Complex UI**: Engine has sophisticated JavaScript requirements

### Trade-offs
- ➕ **Complete isolation** - no conflicts with main app
- ➕ **Independent deployment** - can be distributed as gem
- ➕ **Clear boundaries** - easy to understand ownership
- ➖ **More setup complexity** - custom importmap configuration required
- ➖ **Larger bundle size** - duplicate dependencies
- ➖ **Manual integration** - requires custom helper usage

## 🏠 Approach 2: Main App Integration (`blogh_main_app_layout`)

### What It Is
A **lightweight Rails engine** that leverages the main application's existing Stimulus setup and layout.

### Key Features
- ✅ Uses main app's importmap
- ✅ Shares main app's Stimulus instance
- ✅ Inherits main app styling
- ✅ Automatic controller discovery
- ✅ Single asset bundle

### JavaScript Architecture
```javascript
// Controllers automatically discovered by main app
// app/javascript/controllers/blogh/blogh_controller.js
// Registered as "blogh" controller in main app's Stimulus
```

### When to Choose
- 🎯 **Feature Extensions**: Adding functionality to existing app
- 🎯 **Admin Panels**: Management interfaces for main app
- 🎯 **Content Management**: Editorial tools within main app
- 🎯 **Consistent UX**: Want engine to match main app exactly
- 🎯 **Simple Integration**: Quick setup with minimal configuration

### Trade-offs
- ➕ **Simple setup** - no custom JavaScript configuration
- ➕ **Consistent UX** - automatically matches main app
- ➕ **Shared dependencies** - smaller overall bundle size
- ➕ **Automatic integration** - works with main app's importmap
- ➖ **Coupled to main app** - cannot function independently
- ➖ **Shared fate** - main app JS changes affect engine
- ➖ **Less isolation** - potential for conflicts

## 🤔 Decision Matrix

Use this matrix to choose the right approach:

| Requirement | Isolated | Main App |
|-------------|----------|----------|
| **Independent deployment** | ✅ | ❌ |
| **Quick setup** | ❌ | ✅ |
| **Consistent styling** | ❌ | ✅ |
| **Version independence** | ✅ | ❌ |
| **Reusable across apps** | ✅ | ❌ |
| **Small bundle size** | ❌ | ✅ |
| **Team isolation** | ✅ | ❌ |
| **Simple maintenance** | ❌ | ✅ |

## 🚀 Getting Started

### Option 1: Try the Isolated Engine
```bash
cd blogh_isolate
bundle install
cd test/dummy
rails server
# Visit http://localhost:3000/blogh
```

### Option 2: Try the Main App Integration
```bash
cd blogh_main_app_layout  
bundle install
cd test/dummy
rails server
# Visit http://localhost:3000/blogh
```

## 📝 Implementation Details

### Isolated Engine Key Code
```ruby
# config/importmap.rb
pin_all_from Blogh::Engine.root.join("app/javascript/blogh/controllers"), 
             under: "controllers", 
             to: "blogh/controllers"

# Custom helper
def blogh_importmap_tags(entry_point = "blogh/application")
  importmap = Blogh.configuration.importmap
  # Generate engine-specific importmap...
end
```

### Main App Integration Key Code
```ruby
# Main app's config/importmap.rb automatically includes:
pin_all_from "app/javascript/controllers", under: "controllers"
# This picks up controllers/blogh/ directory from engine

# Engine controller naming:
# controllers/blogh/post_controller.js → "blogh--post" 
```

## 🔧 Development Workflow

### For Isolated Engine
1. Develop engine in isolation
2. Test with dummy app
3. Package as gem
4. Install in main app
5. Use `blogh_importmap_tags` helper

### For Main App Integration  
1. Develop engine alongside main app
2. Controllers automatically discovered
3. Test integration continuously
4. Deploy together

## 🌟 Real-World Examples

### Isolated Engine Use Cases
- **E-commerce Engine**: Product catalog with advanced filtering
- **CMS Engine**: Content management with rich editor
- **Analytics Dashboard**: Complex data visualization
- **Chat Engine**: Real-time messaging with WebSocket

### Main App Integration Use Cases
- **Admin Interface**: User management for main app
- **Blog Module**: Simple blog functionality
- **Comment System**: User comments on main app content
- **Settings Panel**: Application configuration interface

## 🚧 Migration Between Approaches

### From Main App → Isolated
1. Create engine importmap configuration
2. Set up isolated JavaScript structure  
3. Implement custom importmap helper
4. Create engine-specific layout
5. Update controller references

### From Isolated → Main App
1. Move controllers to main app structure
2. Remove custom importmap configuration
3. Update layout to use main app's
4. Remove custom helper usage
5. Update controller naming

## 📚 Further Reading

- **[Isolated Engine README](./blogh_isolate/README.md)** - Deep dive into isolated setup
- **[Main App Integration README](./blogh_main_app_layout/README.md)** - Integration approach details
- **[Rails Engines Guide](https://guides.rubyonrails.org/engines.html)** - Official Rails documentation
- **[Stimulus Handbook](https://stimulus.hotwired.dev/)** - Stimulus framework documentation
- **[Importmap Rails](https://github.com/rails/importmap-rails)** - Import mapping for Rails

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

---

**Choose your approach** and start building! Both examples provide complete, working implementations you can learn from and adapt to your needs.