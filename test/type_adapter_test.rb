require "test/unit"

$LOAD_PATH.unshift("../lib")
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/gen-rb")

require 'type_adapter'
require_relative 'gen-rb/checkin_service'

class TestTypeAdapterStruct < Test::Unit::TestCase

  def setup
    @adapter = TypeAdapter.new(
      { class: Checkin, type: ::Thrift::Types::STRUCT }, 
      { 
        user: { id: 1, username: "John Doe" }, 
        timestamp: 1421512067 
      }
    )
  end

  def test_type_conversion
    assert_equal(@adapter.adapted.class, Checkin)
  end

  def test_user_attribute_conversion
    assert_equal(@adapter.adapted.user.class, User)
    assert_equal(@adapter.adapted.user.id, 1)
  end

  def test_timestamp_attribute_conversion
    assert_equal(@adapter.adapted.timestamp, 1421512067)
  end

end

class TestTypeAdapterList < Test::Unit::TestCase

  def setup
    @adapter = TypeAdapter.new(
      { type: ::Thrift::Types::LIST, element: { class: User, type: ::Thrift::Types::STRUCT } }, 
      [
        { id: 1, username: "John Doe" }, 
        { id: 2, username: "Mary Doe" }, 
      ]
    )
  end

  def test_attribute_conversion
    assert_equal(@adapter.adapted[0].class, User)
    assert_equal(@adapter.adapted[1].id, 2)
  end

end