require 'kramdown/parser/kramdown'

module Docbert
  module Converters
    class StepDefinitions < Kramdown::Converter::Base
      Kramdown::Converter::StepDefinitions = self

      def convert(root)
        root.
          children.
          map { |el| send("convert_#{el.type}", el) }.
          compact.
          join("\n")
      end

      private

      def convert_example_definition(el)
        title_el, body_el = el.children

        title    = convert_example_definition_title(title_el)
        par_list = if title.params.empty?
                     ''
                   else
                     '|' << title.params.join(', ') << '|'
                   end
        body  = convert_example_definition_body(body_el)

        <<-STEPD
        Given(/^#{title}$/) do #{par_list}
          steps <<-EOS
          #{body}
          EOS
        end

        STEPD
      end

      def convert_example_definition_body(el)
        ParameterizedContent.new(el) { |p| '#{' + p + '}' }
      end

      def convert_example_definition_title(el)
        ParameterizedContent.new(el) { |p| '(.+)' }
      end

      def method_missing(name, *args)
        super if name.to_s !~ /^convert_/
      end
    end
  end
end
