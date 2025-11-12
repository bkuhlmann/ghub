# frozen_string_literal: true

RSpec::Matchers.define :match_inspection do |prefix: "@", delimiter: "=", separator: ", ", **|
  match do |actual|
    @content = expected.map { |key, value| "#{prefix}#{key}#{delimiter}#{value}" }
                       .join separator

    actual.match?(/#{@content}/)
  end

  failure_message do |actual|
    <<~MESSAGE
      expected:

      #{actual.inspect.gsub separator, "#{separator}\n"}

      to match:

      #{@content.gsub separator, "#{separator}\n"}
    MESSAGE
  end
end
