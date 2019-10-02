# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
 Rails.application.config.assets.precompile += %w( 
 	sub/modules/fontawesome/css/all.min.css 
 	sub/modules/owlcarousel2/dist/assets/owl.theme.default.min.css
 	sub/modules/owlcarousel2/dist/assets/owl.carousel.min.css
 	sub/modules/bootstrap-social/bootstrap-social.css
 	sub/modules/select2/dist/css/select2.min.css
 	sub/style.css
 	sub/components.css
 	sub/custom.css
 	sub/chat.css
 	sub/bootstrap-material-datetimepicker.css
 )

 Rails.application.config.assets.precompile += %w( 
 	sub/rails-ujs-sweetalert2.js
 	sub/modules/popper.js 
 	sub/modules/tooltip.js
 	sub/modules/bootstrap/js/bootstrap.min.js
 	sub/modules/nicescroll/jquery.nicescroll.min.js
 	sub/modules/moment.min.js
 	sub/modules/owlcarousel2/dist/owl.carousel.min.js
 	sub/modules/cleave-js/dist/cleave.min.js
 	sub/modules/select2/dist/js/select2.min.js
 	sub/modules/chart.min.js
 	sub/custom.js
 	sub/owl.js
 	sub/dashboard.js
 	sub/bootstrap-material-datetimepicker.js
 	sub/price-counter.js
 	sub/rails-gmaps.js
 	sub/jquery.placepicker.js
 )
