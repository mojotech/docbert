module Docbert
  class Parser
    class DefinitionNode < ExampleNode
      def initialize(element_factory, fragment)
        super :example_definition,
              EXAMPLE_DEFINITION_START,
              EXAMPLE_KEYWORDS,
              element_factory,
              fragment
      end

      protected

      def parse_title(frag)
        super.tap { |el|
          content = ParameterizedContent.new(element_factory, el.value)

          el.children.concat content.to_elements
        }
      end

      def parse_body(frag)
        super.tap { |el|
          content = ParameterizedContent.new(element_factory, el.value)

          el.children.concat content.to_elements
        }
      end
    end
  end
end
