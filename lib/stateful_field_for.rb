require "stateful_field_for/version"

module StatefulFieldFor
  def stateful_field_for(attr_name, options = {}, &block)
    definition = Definition.new(attr_name, options)
    definition.instance_eval(&block)
    const_set definition.module_name, definition._module
    include definition._module
  end
end

require "stateful_field_for/definition"
require "stateful_field_for/railtie" if defined?(Rails)
