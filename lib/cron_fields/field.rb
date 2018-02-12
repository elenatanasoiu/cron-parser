module CronFields
  class Field
    attr_accessor :field, :errors, :output
    
    def class_name
      self.class.name.split("::").last.downcase
    end

    def valid?
      errors.empty?
    end
    
    private

    def add_error(message)
      errors << message unless errors.include?(message)
    end

    def format_repeat
      begin
        repeat = self.class::REPEAT_REGEX.match(field).captures.first.to_i
        raise StandardError if repeat.nil?
      rescue StandardError => e
        add_error "FormatError for #{self.class.name}: Number is missing for */15 format"
        return ""
      end
      generate_series(repeat)
    end

    def generate_series(step)
      series_in_steps = self.class::VALID_RANGE.step(step)
      series_in_steps.map(&:to_s).join(" ")
    end

    def format_range
      begin
        first, last = self.class::RANGE_REGEX.match(field).captures.map(&:to_i)
        raise StandardError  if first > last
      rescue StandardError => e
        add_error "FormatError for #{class_name} field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5"
        return ""
      end
      [*first..last].join(" ")
    end

    def format_comma_list
      list = field.split(",").map(&:to_i)
      if list.sort != list
        add_error "FormatError for #{class_name} field: Comma separated list needs to be consecutive"
        return ""
      end
      list.join(" ")
    end

    def format_named_field_range
      begin
        first, last = self.class::NAMED_RANGE_REGEX.match(field).captures.map(&:downcase)
        first = self.class::NAME2NUM[first]
        last = self.class::NAME2NUM[last]
        raise StandardError  if first > last
      rescue StandardError => e
        add_error "FormatError for #{class_name} field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5"
        return ""
      end
      [*first..last].join(" ")
    end

    def format_named_field_comma_list
      list = field.split(",").map{|name| self.class::NAME2NUM[name.downcase]}
      if list.sort != list
        add_error "FormatError for #{class_name} field: Comma separated list needs to be consecutive"
        return ""
      end
      list.join(" ")
    end
  end
end
