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

	def args_and_help
	  {
			"-h" => "Service host",
			"-p" => "Service port",
			"-s" => "The name of the service (as defined on the IDL)",
			"-m" => "The method getting called (as defined on the IDL)",
			"-a" => "The arguments for the call as a Ruby Hash"
		}
	end

	def usage_string
		args_and_help.map { |k, v|
			"  #{k.ljust(4)} #{v}"
		}
	end

	def validate_configs!(arg_map)
		missing = args_and_help.keys.select { |k| arg_map[k].nil? }
		if !missing.empty?
			puts "Missing required parameters: #{missing.join(', ')}\n\n"
			puts "Required parameters:"
			puts usage_string
			puts "\nExample usage:\n"
			puts "thrurl -h \"localhost\" -p 5000 -m \"checkinsPerLocation\" -s \"CheckinService\" -a \"{ user: { id: 1 } }\"\n\n"
			exit 1
		end
	end
end