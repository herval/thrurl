class ThriftGenerator

	GEN_FOLDER = "gen-rb"

	def initialize(module_name)
		@base_dir = File.expand_path Dir.getwd
		@module_name = module_name
		@idl = "#{module_name.downcase}.thrift"
	end

	def generate_if_needed(&block)
		# puts "Generating Ruby classes for all available thrift files in #{@base_dir}/#{GEN_FOLDER}"
		Dir.glob("*.thrift").each { |f|
			# puts "Compiling #{f}"
			`thrift -r --gen rb #{f}`
		}

		service_file = @base_dir + "/#{GEN_FOLDER}/#{@module_name.downcase}.rb"
		
		if !File.exists?(service_file)
			puts "Could not generate code for module #{@module_name} - can't find .thrift file"
			exit 1
		end

		load_module(service_file)
	end

	def load_module(service_file)
		$LOAD_PATH.unshift(GEN_FOLDER)
		require service_file
		eval(@module_name)
  end		

end