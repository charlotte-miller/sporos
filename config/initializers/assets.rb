# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.paths << Rails.root.join('app','assets','fonts')
Rails.application.config.assets.paths << Rails.root.join('vendor', 'assets', 'javascripts', 'bower_components')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w{ vendor.js admin.js admin.css}
Rails.application.config.assets.precompile += %w{ pickadate/lib/themes/default.css pickadate/lib/themes/default.date.css pickadate/lib/themes/default.time.css image-picker/image-picker/image-picker.css}
Rails.application.config.assets.precompile += ['page_initializers/*.js','community/posts/all.js']
Rails.application.config.assets.precompile += ['library/*.js']
# Rails.application.config.assets.precompile += ['community/**/*.js']

Rails.application.config.assets.image_optim = {pngout:false, svgo: false, pack:true, skip_missing_workers:true}

# Rails.application.config.react.variant = :production
# Rails.application.config.react.addons = true