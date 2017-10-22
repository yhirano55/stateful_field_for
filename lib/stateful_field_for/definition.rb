module StatefulFieldFor
  class Definition
    attr_reader :attr_name, :prefix, :suffix, :scope, :logic

    def initialize(attr_name, options = {})
      @attr_name = attr_name
      @prefix    = options[:prefix]
      @suffix    = options[:suffix]
      @scope     = options[:scope] || false
      @logic     = (options[:type] == :date) ? "Date.today" : "Time.current"
    end

    def _module
      @_module ||= Module.new do
        def self.included(klass)
          __define_scope_for_activate(klass)   if respond_to?(:__define_scope_for_activate)
          __define_scope_for_deactivate(klass) if respond_to?(:__define_scope_for_deactivate)
          __define_after_initialize(klass)     if respond_to?(:__define_after_initialize)
        end
      end
    end

    def module_name
      "generated_#{attr_name}_stateful_methods".split("_").map(&:camelize).join
    end

    private

      def enable(event_basename, to: nil, initial: false)
        event = format_name(event_basename)
        state = to.nil? ? event : format_name(to)

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{state}?
            !#{attr_name}.nil?
          end

          def #{event}
            self.#{attr_name} = #{logic}
          end

          def #{event}!(options = {})
            #{event}
            save!(options)
          end
        RUBY

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1 if scope
          def self.__define_scope_for_activate(klass)
            klass.scope :#{state}, -> { where.not(#{attr_name}: nil) }
          end
        RUBY

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1 if initial
          def self.__define_after_initialize(klass)
            klass.after_initialize :#{event}
          end
        RUBY
      end

      def disable(event_basename, to: nil, initial: false)
        event = format_name(event_basename)
        state = to.nil? ? event : format_name(to)

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{state}?
            #{attr_name}.nil?
          end

          def #{event}
            self.#{attr_name} = nil
          end

          def #{event}!(options = {})
            #{event}
            save!(options)
          end
        RUBY

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1 if scope
          def self.__define_scope_for_deactivate(klass)
            klass.scope :#{state}, -> { where(#{attr_name}: nil) }
          end
        RUBY

        _module.module_eval <<-RUBY, __FILE__, __LINE__ + 1 if initial
          def self.__define_after_initialize(klass)
            klass.after_initialize :#{event}
          end
        RUBY
      end

      def format_name(basename)
        [prefix, basename, suffix].compact.join("_")
      end
  end
end
