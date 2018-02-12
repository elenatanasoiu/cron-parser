module CronFields
  class DayOfMonth < Field
    VALID_RANGE = (1..31)
    DAY_REGEX = /^(3[01]|[12][0-9]|[1-9])$/
    RANGE_REGEX = /^(3[01]|[12][0-9]|[1-9])-(3[01]|[12][0-9]|[1-9])$/
    COMMA_REGEX = /^(3[01]|[12][0-9]|[1-9])(?:, ?(3[01]|[12][0-9]|[1-9]))*$/
    
    def initialize(day_of_month)
      @field = day_of_month
      @errors = []
      @output = "day of month  #{parsed_content}"
    end
    
    def parsed_content
      output = case field
        when "*"
          [*VALID_RANGE].join(" ")
        when DAY_REGEX # 15
          field
        when RANGE_REGEX # 1-15
          format_range
        when COMMA_REGEX # 0,12,15,23
          format_comma_list
        else
          add_error "FormatError for dayofmonth field: Day of month has to be either '*', a number between #{VALID_RANGE}, a range 1-15, or a list of days '1,15,16,23,31'"
          nil
      end
    end
  end
end

