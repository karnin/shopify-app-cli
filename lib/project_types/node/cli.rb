module Node
  class Project < ShopifyCli::ProjectType
    register_command('Node::Commands::Serve', "serve")
    # register_task('Node::Tasks::NodeTask', 'node_task')
  end

  # define/autoload project specific Commads
  module Commands
    autoload :Serve, 'project_types/node/commands/serve'
  end

  # define/autoload project specific Tasks
  module Tasks
  end
end
