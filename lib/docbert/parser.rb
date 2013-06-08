require 'kramdown/parser/kramdown'

module Docbert
  class Parser < Kramdown::Parser::Kramdown
    EXAMPLE_KEYWORDS = "Given|When|Then|And|But|\\|"
    EXAMPLE_START    = /#{BLANK_LINE}?^\s*Example:/

    def initialize(source, options)
      super

      register_example_parser
    end

    private

    def example_body_regexp(keywords)
      /(?:\s*(?:#{keywords}).+?\n|#{BLANK_LINE})+/m
    end

    # Parse an example block.
    #
    # Currently only creates 2 nodes: one for the title and another for the
    # example body.
    def parse_example
      build_example_node :example, EXAMPLE_START, EXAMPLE_KEYWORDS
    end

    def build_example_node(root_name, start_regexp, keywords_regexp)
      @src.skip start_regexp

      example  = new_block_el(root_name)
      title_el = Element.new(:example_title, @src.scan(/.+?\n/).strip)
      body     = @src.
        scan(example_body_regexp(keywords_regexp)).
        gsub(/^ +/, '').
        strip
      body_el  = Element.new(:example_body, body)

      example.children << title_el << body_el

      @tree.children << example
    end

    def register_example_parser
      @block_parsers.unshift(:example)
    end

    Kramdown::Parser::Docbert = self

    define_parser :example, /#{EXAMPLE_START}/
  end
end
