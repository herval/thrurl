class TypeAdapter
 	attr_accessor :adapted

	def initialize(metadata, values)
		case metadata[:type]
		when ::Thrift::Types::STRUCT
			fields = adapt(metadata[:class]::FIELDS.values, values)
			self.adapted = metadata[:class].new(fields)

		when ::Thrift::Types::LIST
			self.adapted = values.map { |v| 
				adapt_field(metadata[:element], v) 
			}

		when ::Thrift::Types::MAP
			self.adapted = Hash[*values.map { |v| 
				[
					adapt_field(metadata[:key], v),
					adapt_field(metadata[:value], v)
				]
			}]

		else
			self.adapted = values
		end
	end

	def field_values
		self.adapted.struct_fields.values.collect { |f| self.adapted.send(f[:name]) }
	end


	private

	def adapt(metadata, values)
		adapted_params = {}
		values.each_with_index { |v, i|
			adapted_params[v.first] = adapt_field(metadata[i], v.last)
		}
		adapted_params
	end

	def adapt_field(metadata, value)
		TypeAdapter.new(metadata, value).adapted
	end

end
