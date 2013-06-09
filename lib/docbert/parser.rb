require 'kramdown/parser/kramdown'

module Docbert
  class Parser < Kramdown::Parser::Kramdown
    EXAMPLE_START            = /#{BLANK_LINE}?^\s*Example:/
    EXAMPLE_DEFINITION_START = /#{BLANK_LINE}?^\s*Definition:/
    EXAMPLE_OUTLINE_START    = /#{BLANK_LINE}?^\s*Example Outline:/

    def initialize(source, options)
      super

      register_example_definition_parser
      register_example_outline_parser
      register_example_parser
    end

    public :new_block_el

    def new_el(type, value)
      Element.new(type, value)
    end

    private

    def parse_example
      @tree.children << ExampleNode.as_example(self, @src).to_element
    end

    def parse_example_definition
      @tree.children << ExampleNode.as_definition(self, @src).to_element
    end

    def parse_example_outline
      @tree.children << ExampleNode.as_example_outline(self, @src).to_element
    end

    def register_example_definition_parser
      @block_parsers.unshift(:example_definition)
    end

    def register_example_parser
      @block_parsers.unshift(:example)
    end

    def register_example_outline_parser
      @block_parsers.unshift(:example_outline)
    end

    Kramdown::Parser::Docbert = self

    define_parser :example, /#{EXAMPLE_START}/
    define_parser :example_definition, /#{EXAMPLE_DEFINITION_START}/
    define_parser :example_outline, /#{EXAMPLE_OUTLINE_START}/
  end
end
