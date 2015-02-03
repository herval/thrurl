require_relative 'object_inspector'
require 'pp'

class MethodCall
	attr_accessor :args
 
	def initialize(service_name, method, values)
		eval(service_name)

		args_type = evaluate_method(service_name, method)

		args = evaluate_args(args_type, values)

		self.args = [method] + args
	end

	def evaluate_method(service_name, method)
		args_type = eval("#{service_name}::#{upcase_first(method)}_args") rescue nil

		if args_type.nil?
			puts "\nMethod not found: #{method}\n\nThe following methods are available:"
			puts inspect_methods(service_name)
			exit 1
		end

		args_type
	end		

	def evaluate_args(args_type, values)
		args = TypeAdapter.new(
			{ type: ::Thrift::Types::STRUCT, class: args_type }, 
			values
		).field_values rescue nil

		if args.nil?
			puts "Error processing args: #{values.to_json}\nExpected args:\n\n"
			pp inspect_args(args_type)
			exit 1
		end

		args
	end

	def inspect_args(args_type)
		ObjectInspector.new(args_type).type_tree
	end

	def inspect_methods(service_name)
		base_class = eval(service_name)
		methods = base_class.constants.map { |c| 
			c.to_s.split("_args").first if c.to_s.end_with?("_args")
		}.compact
	  methods.join("\n")
	end
 
	def upcase_first(str)
		str[0].upcase + str[1..-1]
	end
end