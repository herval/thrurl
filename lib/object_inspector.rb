# this is rather hacky, but...
require 'thrift/types'

class ObjectInspector

  def initialize(obj)
    @obj = obj
  end

  def to_json
    to_hash(@obj).to_json
  end

  def type_tree
    type_tree_for(@obj, {})
  end

  private

  def type_tree_for(obj, tree)
    obj::FIELDS.values.map { |f| type_annotation_for(f, tree) }
    tree
  end

  def type_annotation_for(field, tree)
    if(field[:class])
      tree[field_name(field)] = type_tree_for(field[:class], {})
    elsif field[:type] == ::Thrift::Types::SET || field[:type] == ::Thrift::Types::LIST
      tree[field_name(field)] = type_annotation_for(field[:element], {}).values
    else
      tree[field_name(field)] = type_name(field[:type])
    end
    tree
  end

  def field_name(field)
    if field[:optional]
      "#{field[:name]} (optional)"
    else
      field[:name]
    end
  end

  def type_name(constant)
    case constant
      when ::Thrift::Types::BOOL
        Bool
      when ::Thrift::Types::BYTE, ::Thrift::Types::I16, ::Thrift::Types::I32, ::Thrift::Types::I64
        Integer
      when ::Thrift::Types::DOUBLE
        Double
      when ::Thrift::Types::STRING
        String
      end
  end

  def to_hash(obj)
    if obj.is_a?(Hash)
      Hash[*
        obj.map { |key_value| 
          [to_hash(key_value.first), to_hash(key_value.last)] 
        }.flatten
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