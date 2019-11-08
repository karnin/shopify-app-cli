# frozen_string_literal: true

require "tmpdir"
require "fileutils"

ASM_SCRIPT_SOURCE = "git://github.com/AssemblyScript/assemblyscript#ce0457e9edd87c04179ce16ee99753205521aa21"
INSTALL_ASSEMBLY_SCRIPT = "npm i -D ts-node typescript #{ASM_SCRIPT_SOURCE} > /dev/null 2>&1"
TSCONFIG_FILE = "tsconfig.json"
TSCONFIG = "{
  \"extends\": \"./node_modules/assemblyscript/std/assembly.json\",
}"
ALLOCATE_FUNC = "\n\nexport function shopify_runtime_allocate(size: u32): ArrayBuffer { return new ArrayBuffer(size); }"
GQL_BUILDER="GraphQLBuilder.ts"
GQL_TRANSFORM="#{File.dirname(__FILE__)}/#{GQL_BUILDER}"
ASM_SCRIPT_OPTIMIZED = "npx asc %{script}.ts -b build/%{script}.wasm --sourceMap --validate \
--optimize --use abort= --runtime none --transform=#{GQL_BUILDER}"

module ShopifyCli
  module ScriptModule
    module Infrastructure
      class TypeScriptWasmBuilder
        attr_reader :script

        def initialize(script)
          @script = script
        end

        def build
          prepare
          install_builder_framework
          compile
          [bytecode, schema]
        end

        def compiled_type
          "wasm"
        end

        private

        def prepare
          open(script.main_source_file, "a") { |fh| fh.puts(ALLOCATE_FUNC) }
          File.write(TSCONFIG_FILE, TSCONFIG)
        end

        def install_builder_framework
          FileUtils.cp(GQL_TRANSFORM, GQL_BUILDER)
          File.write("package.json", "{}")
          system(INSTALL_ASSEMBLY_SCRIPT)
        end

        def compile
          build_success = system(format(ASM_SCRIPT_OPTIMIZED, script: script.name))
          raise Domain::ServiceFailureError unless build_success
        end

        def bytecode
          File.read("build/#{script.name}.wasm")
        end

        def schema
          File.read("schema")
        end
      end
    end
  end
end