require 'thrift'
require 'json'
require_relative 'method_call'
require_relative 'type_adapter'

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
		resp
	end

end