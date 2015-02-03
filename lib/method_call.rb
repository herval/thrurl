require_relative 'object_inspector'
require 'pp'

class MethodCall
	attr_accessor :args
 
	def initialize(service_name, method, values)
		eval(service_name)

		args_type = eval("#{service_name}::#{upcase_first(method)}_args") rescue nil

		evaluate_method(args_type, service_name, method)
		@inspector = ObjectInspector.new(args_type.new)

		args = evaluate_args(args_type, values)

		self.args = [method] + args
	end

	def evaluate_method(args_type, service_name, method)
		if args_type.nil?
			puts "\nMethod not found: #{method}\n\nThe following methods are available:"
			puts inspect_methods(service_name)
			exit 1
		end
	end		

	def evaluate_args(args_type, values)
		args = TypeAdapter.new(
			{ type: ::Thrift::Types::STRUCT, class: args_type }, 
			values
		).field_values rescue nil

		if args.nil?
			puts "Error processing args: #{values.to_json}\nExpected args:\n"
			pp inspect_args
			puts "\nExample argument with all optional fields:\n\n"
			puts sample_call
			exit 1
		end

		args
	end

	def inspect_args
		@inspector.args_tree
	end

	def sample_call
		@inspector.sample_call
	end

	def inspect_methods(base_class)
		ObjectInspector.new(eval(base_class)).available_methods.join("\n")
	end
 
	def upcase_first(str)
		str[0].upcase + str[1..-1]
	end
end