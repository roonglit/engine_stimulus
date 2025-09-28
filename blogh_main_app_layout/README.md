# Blogh Main App Layout

A Rails engine that **integrates with the main application's layout and Stimulus setup** - leverages the host application's existing JavaScript infrastructure while providing modular functionality.

## Key Features

- 🏠 **Main App Integration**: Uses host application's layout and Stimulus setup
- 🔗 **Shared JavaScript**: Leverages main app's importmap and asset pipeline
- 🎯 **Namespaced Controllers**: Engine controllers integrated into main app's Stimulus
- 📦 **Modular Content**: Provides functionality without layout overhead

## Architecture

### JavaScript Structure
```
app/javascript/controllers/blogh/
└── blogh_controller.js     # Stimulus controller for main app
```

### Integration Strategy
- **No Custom Layout**: Engine views render within main app layout
- **Shared Stimulus**: Controllers registered with main application's Stimulus instance  
- **Main App Importmap**: Uses host application's importmap configuration
- **Integrated Assets**: JavaScript bundled with main application assets

### Importmap Integration
The engine's controllers are automatically picked up by the main app's importmap when using:

```ruby
# In main app's config/importmap.rb
pin_all_from "app/javascript/controllers", under: "controllers"
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "blogh", path: "path/to/blogh_main_app_layout"
```

And then execute:
```bash
$ bundle
```

Mount the engine in your `config/routes.rb`:
```ruby
mount Blogh::Engine => "/blogh"
```

## Usage

### In Main Application Layout
The engine renders within your existing application layout:

```erb
<!-- app/views/layouts/application.html.erb -->
<!DOCTYPE html>
<html>
  <head>
    <%= javascript_importmap_tags %> <!-- Main app importmap -->
  </head>
  <body>
    <%= yield %> <!-- Engine content renders here -->
  </body>
</html>
```

### Using Engine Controllers
Engine Stimulus controllers work seamlessly with main app:

```erb
<!-- Engine view using main app's Stimulus -->
<div data-controller="blogh">
  <p>Controlled by blogh_controller.js via main app's Stimulus</p>
</div>
```

### Creating New Controllers
Add controllers in the main app's JavaScript structure:

```javascript
// app/javascript/controllers/blogh/my_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Engine controller via main app Stimulus!")
  }
}
```

Reference them with namespaced names:
```erb
<div data-controller="blogh--my">
  <!-- Controller: blogh/my_controller.js -->
</div>
```

## Development

### Testing the Engine
```bash
cd test/dummy
rails server
```

Visit `http://localhost:3000/blogh` to see the engine in action.

### Main App Integration
To integrate with a real Rails app:

1. **Add to Gemfile**: Include the engine gem
2. **Mount Routes**: Add engine routes to main app
3. **Update Importmap**: Ensure main app's importmap includes engine controllers
4. **Style Integration**: Engine inherits main app's CSS

## How It Works

### Integration Points
1. **Layout Inheritance**: Engine views use `render layout: false` or main app layout
2. **Shared Stimulus**: Controllers register with main app's Stimulus application
3. **Asset Pipeline**: JavaScript compiled with main application bundle
4. **Route Mounting**: Engine routes nested under main app routing

### Controller Registration
Main app's Stimulus automatically discovers engine controllers:

```javascript
// Main app's stimulus setup
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)
// This includes controllers/blogh/ directory
```

### Naming Convention
```
app/javascript/controllers/blogh/blogh_controller.js → "blogh" controller
app/javascript/controllers/blogh/post_controller.js  → "blogh--post" controller
```

## Benefits

- ✅ **Seamless Integration**: No additional JavaScript setup required
- ✅ **Consistent UX**: Engine inherits main app's look and feel
- ✅ **Shared Dependencies**: Leverages main app's JavaScript libraries
- ✅ **Simple Deployment**: No separate asset compilation needed
- ✅ **Performance**: Single JavaScript bundle for entire application

## Trade-offs

### Advantages
- Lighter weight setup
- Consistent styling with main app
- Shared dependencies reduce bundle size
- Simple integration process

### Disadvantages
- Coupled to main app's JavaScript setup
- Cannot be used independently
- Main app updates may affect engine
- Less isolation between components

## Comparison with Isolate Version

| Feature | Main App Layout | Isolate |
|---------|----------------|----------|
| JavaScript Setup | Shared | Independent |
| Layout | Main App | Engine-specific |
| Asset Bundle | Combined | Separate |
| Deployment | Simple | Complex |
| Independence | Low | High |
| Integration | Easy | Manual |

## Migration Guide

### From Isolated to Main App Layout
1. Remove engine's importmap configuration
2. Move controllers to main app's JavaScript structure
3. Update controller references
4. Remove custom layout (optional)

### From Main App Layout to Isolated
1. Create engine importmap configuration  
2. Set up isolated JavaScript structure
3. Create engine-specific layout
4. Implement custom importmap helper

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
