require 'kramdown/parser/kramdown'

module Docbert
  class Parser < Kramdown::Parser::Kramdown
    EXAMPLE_START = /#{BLANK_LINE}?^\s*Example:/
    EXAMPLE_BODY  = /(?:\s*(?:Given|When|Then|And|But|\|).+?\n|#{BLANK_LINE})+/m

    def initialize(source, options)
      super

      register_example_parser
    end

    private

    # Parse an example block.
    #
    # Currently only creates 2 nodes: one for the title and another for the
    # example body.
    def parse_example
      @src.skip EXAMPLE_START

      example  = new_block_el(:example)
      title_el = Element.new(:example_title, @src.scan(/.+?\n/).strip)
      body     = @src.scan(EXAMPLE_BODY).gsub(/^ +/, '').strip
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
