require 'spec_helper'
require_relative '../lib/cron_parser'
require_relative '../lib/cron_fields/field'
require_relative '../lib/cron_fields/minute'
require_relative '../lib/cron_fields/hour'
require_relative '../lib/cron_fields/day_of_month'
require_relative '../lib/cron_fields/month'
require_relative '../lib/cron_fields/day_of_week'

describe CronParser do
  it "sets the right fields" do
    input = "* * * * * /usr/bin/find"
    formatter = described_class.new(input.split(" "))

    expect(formatter.minute).to eq("*")
    expect(formatter.hour).to eq("*")
    expect(formatter.day_of_month).to eq("*")
    expect(formatter.month).to eq("*")
    expect(formatter.day_of_week).to eq("*")
    expect(formatter.command).to eq("/usr/bin/find")
  end
  
  it "should have errors if fields are missing" do
    input = "*"
    formatter = described_class.new(input.split(" "))

    expect(formatter.errors).to_not be_empty
  end

  it "parses the standard string" do
    input = "* * * * * /usr/bin/find"
    formatter = described_class.new(input.split(" "))

    formatter.parse
    expect(formatter.output)
      .to eq(
<<-EOF
minute        0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59
hour          0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23
day of month  1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
month         1 2 3 4 5 6 7 8 9 10 11 12
day of week   1 2 3 4 5 6 7
command       /usr/bin/find
EOF
)
  end

  it "parses an example string" do
    input = "*/15 0 1,15 * 1-5 /usr/bin/find"
    formatter = described_class.new(input.split(" "))
  
    formatter.parse
    expect(formatter.output)
      .to eq(
            <<-EOF
minute        0 15 30 45
hour          0
day of month  1 15
month         1 2 3 4 5 6 7 8 9 10 11 12
day of week   1 2 3 4 5
command       /usr/bin/find
          EOF
          )
  end
end
