module Node
  class Project < ShopifyCli::ProjectType
    register_command('Node::Commands::Serve', "serve")
  end

  module Commands
    autoload :Serve, 'project_types/node/commands/serve'
  end
end
