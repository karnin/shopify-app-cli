class NodeProject < ShopifyCli::ProjectType
  register_command(:Serve, "serve", "commands/serve")
end
