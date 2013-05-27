require 'kramdown/parser/kramdown'

module Docbert
  module Converters
    class Gherkin < Kramdown::Converter::Base
      Kramdown::Converter::Gherkin = self

      def convert(root)
        root.
          children.
          map { |el| send("convert_#{el.type}", el) }.
          compact.
          join("\n")
      end

      private

      def convert_example(el)
        title, body = el.children

        convert_example_title(title, "  ") +
          convert_example_body(body, "    ")
      end

      def convert_example_body(body, indent)
        body.
          value.
          split(/\n/).
          map { |step| "#{indent}#{step.strip}\n" }.
          join
      end

      def convert_example_title(title, indent)
        "#{indent}Scenario: #{title.value}\n"
      end

      # Convert a level 1 header to a feature title.
      #
      # Current limitations:
      #   - Expects one and only one level 1 header to exist
      #   - Doesn't allow additional markup to be specified in the header
      def convert_header(el)
        if el.options[:level] == 1
          feature_title = el.children.first.value

          "Feature: #{feature_title}\n"
        end
      end

      def method_missing(name, *args)
        super if name.to_s !~ /^convert_/
      end
    end
  end
end
