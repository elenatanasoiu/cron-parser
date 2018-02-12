require_relative '../lib/cron_fields/field'
require_relative '../lib/cron_fields/minute'
require_relative '../lib/cron_fields/hour'
require_relative '../lib/cron_fields/day_of_month'
require_relative '../lib/cron_fields/month'
require_relative '../lib/cron_fields/day_of_week'

class CronParser
  attr_accessor :input, :minute, :hour, :day_of_month, :month, :day_of_week, :command, :errors, :output
  
  def initialize(args)
    @input = args
    @minute, @hour, @day_of_month, @month, @day_of_week, @command = args
    @errors = []
    @output = ""
    validate!
  end
  
  def parse
    invoke_parsers
    
    if all_valid?
      output
    else
<<-EOF
********************************************************\n
Input [#{input.join(", ")}] is invalid.\n
********************************************************\n
The following errors have occurred:\n
#{errors.join("\n")}
********************************************************\n"
EOF
    end
  end
  
  private
  
  def validate!
    errors << "Minute field is mandatory" if minute.nil?
    errors << "Hour field is mandatory" if hour.nil?
    errors << "Day of month field is mandatory" if day_of_month.nil?
    errors << "Month field is mandatory" if month.nil?
    errors << "Day of week field is mandatory" if day_of_week.nil?
    errors << "Command field is mandatory" if command.nil?
  end

  def all_valid?
    errors.empty?
  end
  
  def invoke_parsers
    fields = [minute, hour, day_of_month, month, day_of_week]
    parsers = [CronFields::Minute, CronFields::Hour, CronFields::DayOfMonth, CronFields::Month, CronFields::DayOfWeek]
    
    Hash[parsers.zip(fields)].each do |parser_class, value|
      parser = parser_class.new(value)
      parsed_content = parser.output
      
      if parser.valid?
        output << "#{parsed_content}\n"
      else
        errors << parser.errors
      end
    end
    
    output << "command       #{command}\n"
  end
end
