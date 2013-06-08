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
        title, body = el.children

        <<-STEPD
        Given(/^#{title.value}$/) do
          steps <<-EOS
          #{body.value}
          EOS
        end

        STEPD
      end

      def method_missing(name, *args)
        super if name.to_s !~ /^convert_/
      end
    end
  end
end
