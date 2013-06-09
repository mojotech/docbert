module Docbert
  module Converters
    class StepDefinitions
      class ParameterizedContent
        def initialize(el, &block)
          self.el    = el
          self.block = block
        end

        def params
          @params ||= el.
            children.
            select { |e| param?(e) }.
            map    { |e| param(e) }
        end

        def to_s
          @s ||= el.
            children.
            map { |e| param?(e) ? block.(param(e)) : e.value }.
            join
        end

        private

        attr_accessor :el, :block

        def param?(el)
          el.type == :example_definition_param
        end

        def param(el)
          el.value.gsub(' ', '_')
        end
      end
    end
  end
end
