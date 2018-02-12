module CronFields
  class Minute < Field
    VALID_RANGE = (0..59)
    MINUTE_REGEX = /^[1-5]?[0-9]$/
    REPEAT_REGEX = /^\*\/([1-5]?[0-9])$/
    RANGE_REGEX = /^([1-5]?[0-9])-([1-5]?[0-9])$/
    COMMA_REGEX = /^([1-5]?[0-9])(?:, ?([1-5]?[0-9]))*$/
    
    def initialize(minute)
      @field = minute
      @errors = []
      @output = "minute        #{parsed_content}"
    end
    
    def parsed_content
      case field
        when "*"
          [*VALID_RANGE].join(" ")
        when MINUTE_REGEX # 15
          field
        when REPEAT_REGEX # */15
          format_repeat
        when RANGE_REGEX # 1-15
          format_range
        when COMMA_REGEX # 0,15,23,34
          format_comma_list
        else
          add_error "FormatError for minute field: Minute has to be either '*', a number between #{VALID_RANGE}, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'"
          nil
      end
    end
  end
end
