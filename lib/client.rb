require 'thrift'
require 'json'

class Client
	def initialize(client_thrift_class, config)
		@transport = ::Thrift::FramedTransport.new(::Thrift::Socket.new(config[:host], config[:port]))
		protocol = ::Thrift::BinaryProtocol.new(@transport)
 
		@client = client_thrift_class.new(protocol)
		@call = MethodCall.new(config[:service], config[:method], config[:params])
	end
 
	def call
		@transport.open
		resp = @client.send(*@call.args)
		@transport.close
		to_hash(resp).to_json
	end

	private

	def to_hash(obj)
		if obj.is_a?(Hash)
			Hash[*
				obj.map { |key_value| [to_hash(key_value.first), to_hash(key_value.last)] }.flatten
			]
		elsif obj.is_a?(Array)
			obj.map { |f| to_hash(f) }
		elsif obj.is_a?(::Thrift::Struct)
			Hash[*
				obj.struct_fields.values.map { |f| [f[:name], to_hash(obj.send(f[:name]))] }.flatten
			]
		else
			obj
		end
	end
end