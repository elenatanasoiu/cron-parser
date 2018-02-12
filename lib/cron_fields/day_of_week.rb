module CronFields
  class DayOfWeek < Field
    # Number regex
    VALID_RANGE = (1..7)
    DAY_REGEX = /^([1-7])$/
    RANGE_REGEX = /^([1-7])-([1-7])$/
    COMMA_REGEX = /^([1-7])(?:, ?([1-7]))*$/
    
    # Day name regex
    DAYS_OF_WEEK = %w{Mon Tue Wed Thu Fri Sat Sun}
    NAME2NUM = Hash[DAYS_OF_WEEK.map(&:downcase).zip(1..7)]
    DAY_NAME_REGEX = %r{^(#{DAYS_OF_WEEK.join("|")}|)$}i
    NAMED_RANGE_REGEX = %r{^(#{DAYS_OF_WEEK.join("|")})-(#{DAYS_OF_WEEK.join("|")})$}i
    DAY_NAME_COMMA_REGEX = %r{^(#{DAYS_OF_WEEK.join("|")})(?:, ?(#{DAYS_OF_WEEK.join("|")}))*$}i

    def initialize(day_of_week)
      @field = day_of_week
      @errors = []
      @output = "day of week   #{parsed_content}"
    end
    
    def parsed_content
      case field
        when "*"
          [*VALID_RANGE].join(" ")
        when DAY_REGEX # 3
          field
        when RANGE_REGEX # 1-3
          format_range
        when COMMA_REGEX # 1,3,6
          format_comma_list
        when DAY_NAME_REGEX # Mon or MON
          NAME2NUM[field.downcase].to_s
        when NAMED_RANGE_REGEX # Mon-Fri
          format_named_field_range
        when DAY_NAME_COMMA_REGEX # Mon,Wed,Fri,Sat
          format_named_field_comma_list
        else
          add_error "FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'"
          nil
      end
    end
  end
end

