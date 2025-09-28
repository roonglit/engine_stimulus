pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

pin "blogh/application", preload: true

# Pin all controller files following the *_controller.js naming convention 
pin_all_from Blogh::Engine.root.join("app/javascript/blogh/controllers"), under: "controllers", to: "blogh/controllers"
