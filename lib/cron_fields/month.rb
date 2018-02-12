module CronFields
  class Month < Field
    # Number regex
    VALID_RANGE = (1..12)
    MONTH_REGEX = /^(1[0-2]|[1-9])$/
    REPEAT_REGEX = /^\*\/(1[0-2]|[1-9])$/
    RANGE_REGEX = /^(1[0-2]|[1-9])-(1[0-2]|[1-9])$/
    COMMA_REGEX = /^(1[0-2]|[1-9])(?:, ?(1[0-2]|[1-9]))*$/

    # Month name regex
    MONTHS = %w{Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec}
    NAME2NUM = Hash[MONTHS.map(&:downcase).zip(1..12)]
    MONTH_NAME_REGEX = %r{^(#{MONTHS.join("|")}|)$}i
    NAMED_RANGE_REGEX = %r{^(#{MONTHS.join("|")})-(#{MONTHS.join("|")})$}i
    MONTH_NAME_COMMA_REGEX = %r{^(#{MONTHS.join("|")})(?:, ?(#{MONTHS.join("|")}))*$}i
    
    def initialize(month)
      @field = month
      @errors = []
      @output = "month         #{parsed_content}"
    end
    
    def parsed_content
      case field
        when "*"
          [*VALID_RANGE].join(" ")
        when MONTH_REGEX # 3
          field
        when REPEAT_REGEX # */3
          format_repeat
        when RANGE_REGEX # 1-3
          format_range
        when COMMA_REGEX # 1,3,6,9
          format_comma_list
        when MONTH_NAME_REGEX # Dec or DEC
          NAME2NUM[field.downcase].to_s
        when NAMED_RANGE_REGEX # Jan-Mar
          format_named_field_range
        when MONTH_NAME_COMMA_REGEX # Jan,Mar,Jun,Sep
          format_named_field_comma_list
        else
          add_error "FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'"
          nil
      end
    end
  end
end

