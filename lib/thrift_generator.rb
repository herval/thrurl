class ThriftGenerator

	GEN_FOLDER = "gen-rb"

	def initialize(module_name)
		@base_dir = File.expand_path Dir.getwd
		@module_name = module_name
		@idl = "#{module_name.downcase}.thrift"
	end

	def generate_if_needed(&block)
		if !File.directory?("#{@base_dir}/#{GEN_FOLDER}")
			puts "Generating Ruby classes in #{@base_dir}/#{GEN_FOLDER}"
			`thrift -r --gen rb #{@idl}`
		end
		$LOAD_PATH.unshift(GEN_FOLDER)
		require @base_dir + "/#{GEN_FOLDER}/#{@module_name.downcase}.rb"
		eval(@module_name)
	end

end