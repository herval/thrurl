class MethodCall
	attr_accessor :args
 
	def initialize(service_name, method, values)
		args_type = eval("#{service_name}::#{upcase_first(method)}_args")
		args = TypeAdapter.new(
			{ type: ::Thrift::Types::STRUCT, class: args_type }, 
			values
		).field_values

		self.args = [method] + args
	end
 
	def upcase_first(str)
		str[0].upcase + str[1..-1]
	end
end