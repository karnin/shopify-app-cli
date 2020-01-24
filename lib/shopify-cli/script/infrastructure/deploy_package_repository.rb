# frozen_string_literal: true

module ShopifyCli
  module ScriptModule
    module Infrastructure
      class DeployPackageRepository < Repository
        def create_deploy_package(script, script_content, schema, content_type)
          build_file_path = file_path(script.name, content_type)
          write_to_path(
            build_file_path,
            script_content
          )
          Domain::DeployPackage.new(
            build_file_path,
            script,
            script_content,
            content_type,
            schema
          )
        end

        def get_deploy_package(script, extension_point_type, script_name, content_type)
          build_file_path = file_path(script_name, content_type)

          raise Domain::DeployPackageNotFoundError.new(
            extension_point_type,
            script_name
          ) unless File.exist?(build_file_path)

          script_content = File.read(build_file_path)
          schema_path = schema_path(script_name)
          schema = File.exist?(schema_path) ? File.read(schema_path) : ''

          Domain::DeployPackage.new(
            build_file_path,
            script,
            script_content,
            content_type,
            schema
          )
        end

        private

        def write_to_path(path, content)
          FileUtils.mkdir_p(File.dirname(path))
          File.write(path, content)
        end

        def file_path(script_name, content_type)
          "#{script_base_path(script_name)}/src/build/#{script_name}.#{content_type}"
        end

        def schema_path(script_name)
          "#{script_base_path(script_name)}/temp/schema"
        end

        def script_base_path(script_name)
          format(FOLDER_PATH_TEMPLATE, script_name: script_name)
        end
      end
    end
  end
end