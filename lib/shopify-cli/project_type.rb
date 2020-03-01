module ShopifyCli
  class ProjectType
    class << self
      def load_project_type(current_type)
        filepath = File.join(ROOT, 'lib', 'project_types', current_type.to_s, 'cli.rb')
        return unless File.exist?(filepath)
        @current_type = current_type
        require(filepath)
        @current_type = nil
      end

      def repository
        @repository ||= []
      end

      def inherited(klass)
        repository << klass
        klass.project_type = @current_type
      end

      def for_app_type(type)
        repository.find do |klass|
          klass.project_type.to_sym == type.to_sym
        end
      end

      def project_type=(type)
        @project_type = type
      end

      def project_type
        @project_type
      end

      def register_command(const, cmd, path = nil)
        project_path = File.join(ShopifyCli::PROJECT_TYPES_DIR, @project_type.to_s, path)
        Commands.register(const, cmd, project_path)
      end
    end
  end
end
