# this is rather hacky, but...
require 'thrift/types'

class ObjectInspector
  def initialize(obj)
    @obj = obj
  end

  def sample_call
    type_tree_for(@obj.class, {}, sample_values)
  end

  def args_tree
    type_tree_for(@obj.class, {}, type_names)
  end

  def response_map
    response_tree(@obj, {})
  end

  def available_methods
    @obj.constants.map { |c| 
      c.to_s.split("_args").first if c.to_s.end_with?("_args")
    }.compact
  end

  private

  def response_tree(obj, tree)
    obj.struct_fields.values.each { |i|
      tree[i[:name]] = response_fields(obj.send(i[:name]))
    }
    tree
  end

  def response_fields(obj)
    if obj.is_a?(Array)
      obj.map { |f| response_fields(f) }
    elsif obj.is_a?(Hash)
      Hash[*
        obj.each { |k, v|
          [k, response_fields(v)]
        }
      ]
    elsif obj.is_a?(::Thrift::Struct)
      response_tree(obj, {})
    else
      obj
    end
  end

  def type_tree_for(obj, tree, value_mapping)
    obj::FIELDS.values.map { |f| type_annotation_for(f, tree, value_mapping) }
    tree
  end

  def type_annotation_for(field, tree, value_mapping)
    if(field[:class])
      tree[field_name(field)] = type_tree_for(field[:class], {}, value_mapping)
    elsif field[:type] == ::Thrift::Types::MAP
      tree[field_name(field)] = { 
        type_annotation_for(field[:key], {}, value_mapping).values.first => 
          type_annotation_for(field[:value], {}, value_mapping).values.first
      }
    elsif field[:type] == ::Thrift::Types::SET || field[:type] == ::Thrift::Types::LIST
      tree[field_name(field)] = type_annotation_for(field[:element], {}, value_mapping).values
    else
      tree[field_name(field)] = value_mapping[field[:type]]
    end
    tree
  end

  def field_name(field)
    field[:name]
  end

  def type_names
    {
      ::Thrift::Types::BOOL => "boolean",
      ::Thrift::Types::BYTE => "integer",
      ::Thrift::Types::I16 => "integer",
      ::Thrift::Types::I32 => "integer",
      ::Thrift::Types::I64 => "integer",
      ::Thrift::Types::DOUBLE => "double",
      ::Thrift::Types::STRING => "string"
    }
  end

  def sample_values
    {
      ::Thrift::Types::BOOL => true,
      ::Thrift::Types::BYTE => 1,
      ::Thrift::Types::I16 => 12,
      ::Thrift::Types::I32 => 123,
      ::Thrift::Types::I64 => 1234,
      ::Thrift::Types::DOUBLE => 12.34,
      ::Thrift::Types::STRING => "foo"
    }
  end

end