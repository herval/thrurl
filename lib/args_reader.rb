class ArgsReader
	attr_accessor :configs

	def initialize(args)
		arg_map = Hash[*args]
		validate_configs!(arg_map)

		self.configs = {
			host: arg_map["-h"],
			port: arg_map["-p"],
			method: arg_map["-m"],
			service: arg_map["-s"],
			params: eval(arg_map["-a"])
		}
	end

	def validate_configs!(arg_map)
		["-h", "-p", "-m", "-s", "-p"].each do |p|
			raise "Missing required parameter: #{p}" if arg_map[p].nil?
		end
	end
end