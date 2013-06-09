module Docbert
  class Parser
    class ParameterizedContent
      WORDS = /\w(?:\w+| )*\w/

      def initialize(element_factory, fragment)
        self.element_factory = element_factory
        self.scanner         = StringScanner.new(fragment)
        self.elements        = build_elements
      end

      def to_elements
        elements
      end

      private

      attr_accessor :element_factory, :scanner, :elements

      def build_element
        build_text || build_param
      end

      def build_elements(elements = [])
        return elements if scanner.eos?

        build_elements(elements << build_element)
      end

      def build_param
        scanner.skip(/</) and name = scanner.scan(WORDS) and scanner.skip(/>/)

        element_factory.new_el(:example_definition_param, name) if name
      end

      def build_text
        if text = scanner.scan(/[^<]+/)
          element_factory.new_el(:text, text)
        end
      end
    end
  end
end
