module Rails
  class Project < ShopifyCli::ProjectType
    register_command('Rails::Commands::Serve', "serve")
  end

  module Commands
    autoload :Serve, 'project_types/rails/commands/serve'
  end
end
