require "test/unit"

$LOAD_PATH.unshift("../lib")
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/gen-rb")

require 'object_inspector'
require_relative 'gen-rb/checkin_service'

class TestObjectInspector < Test::Unit::TestCase

  def setup
    user = ::User.new({ id: 123, username: "john", permissions: { "to_live" => true, "to_die" => false } })
    @args = CheckinService::CheckinsPerLocation_args.new(user: user)
  end

  def test_args_tree
    @inspector = ObjectInspector.new(@args)
    tree = @inspector.args_tree
    assert tree["user"]["id"] == "integer"
    assert tree["user"]["username"] == "string"
    assert tree["user"]["permissions"] == { "string" => "boolean" }
  end

  def test_sample_call
    @inspector = ObjectInspector.new(@args)
    tree = @inspector.sample_call
    assert tree["user"]["id"] == 123
    assert tree["user"]["username"] == "foo"
    assert tree["user"]["permissions"] == { "foo" => true }
  end


end