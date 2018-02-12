module CronFields
  class Hour < Field
    VALID_RANGE = (0..23)
    HOUR_REGEX = /^(2[0-3]|1[0-9]|[0-9])$/
    REPEAT_REGEX = /^\*\/(2[0-3]|1[0-9]|[0-9])$/
    RANGE_REGEX = /^(2[0-3]|1[0-9]|[0-9])-(2[0-3]|1[0-9]|[0-9])$/
    COMMA_REGEX = /^(2[0-3]|1[0-9]|[0-9])(?:, ?(2[0-3]|1[0-9]|[0-9]))*$/
    
    def initialize(hour)
      @field = hour
      @errors = []
      @output = "hour          #{parsed_content}"
    end
    
    def parsed_content
      case field
        when "*"
          [*VALID_RANGE].join(" ")
        when HOUR_REGEX # 15
          field
        when REPEAT_REGEX # */15
          format_repeat
        when RANGE_REGEX # 1-15
          format_range
        when COMMA_REGEX # 0,12,15,23
          format_comma_list
        else
          add_error "FormatError for hour field: Hour has to be either '*', a number between #{VALID_RANGE}, an interval '*/15' where 15 is the hour, a range 1-15, or a list of hours '1,15,16,23'"
          nil
      end
    end
  end
end

