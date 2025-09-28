# Blogh Isolate

A Rails engine with **isolated Stimulus setup** - completely self-contained JavaScript architecture that doesn't depend on the main application's Stimulus configuration.

## Key Features

- 🔒 **Isolated Stimulus Setup**: Own importmap, controllers, and JavaScript bundle
- ⚡ **Independent Asset Pipeline**: Self-contained JavaScript compilation
- 🎯 **Engine-Scoped Controllers**: Stimulus controllers namespaced under the engine
- 🔧 **Custom Importmap Helper**: `blogh_importmap_tags` for engine-specific imports

## Architecture

### JavaScript Structure
```
app/javascript/blogh/
├── application.js          # Entry point for engine JS
└── controllers/
    ├── application.js      # Stimulus application setup
    ├── index.js           # Controller registration
    └── engine_controller.js # Example Stimulus controller
```

### Importmap Configuration
The engine uses its own importmap configuration in `config/importmap.rb`:

```ruby
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "blogh/application", preload: true
pin_all_from Blogh::Engine.root.join("app/javascript/blogh/controllers"), 
             under: "controllers", 
             to: "blogh/controllers"
```

### Custom Importmap Helper
Use `blogh_importmap_tags` in your engine layouts:

```erb
<%= blogh_importmap_tags %>
```

This generates:
- Importmap JSON with engine-scoped imports
- Module preload links for performance
- Entry point script tag

## Installation

Add this line to your application's Gemfile:

```ruby
gem "blogh", path: "path/to/blogh_isolate"
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

### In Engine Views
Use the engine's Stimulus controllers with the `data-controller` attribute:

```erb
<div data-controller="engine">
  <p>This will be controlled by engine_controller.js</p>
</div>
```

### Creating New Controllers
Add new Stimulus controllers in `app/javascript/blogh/controllers/`:

```javascript
// app/javascript/blogh/controllers/my_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("My controller connected!")
  }
}
```

They'll be automatically picked up by the `pin_all_from` directive.

### Engine Layout
The engine uses its own layout (`app/views/layouts/blogh/application.html.erb`) which includes:
- Engine-specific importmap tags
- Isolated Stimulus setup
- Engine-scoped CSS

## Development

### Testing the Engine
```bash
cd test/dummy
rails server
```

Visit `http://localhost:3000/blogh` to see the engine in action.

### Adding JavaScript Dependencies
Update `config/importmap.rb` and rebuild:
```bash
./bin/importmap pin <package-name>
```

## How It Works

### Isolation Strategy
1. **Separate Importmap**: Engine maintains its own importmap configuration
2. **Namespaced Assets**: All JS assets compiled under `blogh/` namespace  
3. **Custom Helper**: `blogh_importmap_tags` generates engine-specific import maps
4. **Independent Stimulus**: Engine creates its own Stimulus application instance

### Asset Path Mapping
The `to: "blogh/controllers"` parameter ensures:
```javascript
// Import path in code
import "controllers/engine"

// Maps to actual asset
"/assets/blogh/controllers/engine_controller-abc123.js"
```

## Benefits

- ✅ **No Conflicts**: Engine JS won't interfere with main app
- ✅ **Independent Updates**: Upgrade engine JS without affecting main app
- ✅ **Clear Boundaries**: Easy to understand what belongs to the engine
- ✅ **Testable**: Can test engine JavaScript in isolation

## Troubleshooting

### Controllers Not Loading
1. Ensure controller files end with `_controller.js`
2. Check that `pin_all_from` includes the `to:` parameter
3. Verify `eagerLoadControllersFrom("controllers", application)` path

### Import Errors
1. Check `config/importmap.rb` has correct pins
2. Ensure asset compilation includes engine assets
3. Verify importmap helper is called in layout

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
