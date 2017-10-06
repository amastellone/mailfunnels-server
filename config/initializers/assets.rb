# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# JS Files
Rails.application.config.assets.precompile += %w( pages/login.js )
Rails.application.config.assets.precompile += %w( dashboard_manifest.js )
Rails.application.config.assets.precompile += %w( datatable_manifest.js )
Rails.application.config.assets.precompile += %w( pages/funnels.js )
Rails.application.config.assets.precompile += %w( pages/emailtemplates.js )
Rails.application.config.assets.precompile += %w( triggers_manifest.js )
Rails.application.config.assets.precompile += %w( funnel_builder_manifest.js )
Rails.application.config.assets.precompile += %w( pages/editemailtemplate.js )
Rails.application.config.assets.precompile += %w( pages/emailList.js )
Rails.application.config.assets.precompile += %w( pages/allsubscribers.js )
Rails.application.config.assets.precompile += %w( pages/home.js )
Rails.application.config.assets.precompile += %w( pages/admin_panel.js )
Rails.application.config.assets.precompile += %w( pages/account.js )
Rails.application.config.assets.precompile += %w( components/jquery.tabletoCSV.js )
Rails.application.config.assets.precompile += %w( components/switchery.min.js )
Rails.application.config.assets.precompile += %w( pages/broadcasts.js )



# CSS Files
Rails.application.config.assets.precompile += %w( pages/login.css )
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( components/jquery.flowchart.css )
Rails.application.config.assets.precompile += %w( EmailTemplate/simple.css )
Rails.application.config.assets.precompile += %w( components/switchery.min.css )
Rails.application.config.assets.precompile += %w( custom.css )

