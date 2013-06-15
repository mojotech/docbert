module Docbert
  class Parser
    class ExampleNode
      BLANK_LINE = Kramdown::Parser::Kramdown::BLANK_LINE

      EXAMPLE_KEYWORDS         = 'Given|When|Then|And|But|\\||"""'
      EXAMPLE_OUTLINE_KEYWORDS = "#{EXAMPLE_KEYWORDS}|Examples:"

      def self.as_definition(element_factory, fragment)
        DefinitionNode.new(element_factory, fragment)
      end

      def self.as_example(element_factory, fragment)
        new(:example, EXAMPLE_START, EXAMPLE_KEYWORDS, element_factory, fragment)
      end

      def self.as_example_outline(element_factory, fragment)
        new(:example_outline,
            EXAMPLE_OUTLINE_START,
            EXAMPLE_OUTLINE_KEYWORDS,
            element_factory,
            fragment)
      end

      def initialize(type, start_re, keywords, element_factory, fragment)
        self.type            = type
        self.start_re        = start_re
        self.body_re         = /(?:\s*(?:#{keywords}).+?\n|#{BLANK_LINE})+/m
        self.element_factory = element_factory
        self.fragment        = fragment

        parse
      end

      def to_element
        element
      end

      private

      attr_accessor :type, :start_re, :body_re, :element_factory, :fragment, :element

      # Parse an example block.
      #
      # Currently only creates 2 nodes: one for the title and another for the
      # example body.
      def parse
        skip_start fragment

        self.element = parse_root(fragment)
      end

      def parse_body(frag)
        body = frag.scan(body_re).gsub(/^ +/, '').strip

        element_factory.new_el(:example_body, body)
      end

      def parse_root(frag)
        element_factory.new_block_el(type).
          tap { |el| el.children << parse_title(frag) << parse_body(frag) }
      end

      def parse_title(frag)
        title = frag.scan(/.+?\n/).strip

        element_factory.new_el(:example_title, title)
      end

      def skip_start(frag)
        frag.skip start_re
      end
    end
  end
end
