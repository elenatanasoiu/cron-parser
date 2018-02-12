require 'spec_helper'
require_relative '../../lib/cron_fields/field'
require_relative '../../lib/cron_fields/minute'

describe CronFields::Minute do
  it "parses the * format" do
    formatter = described_class.new("*")
    expect(formatter.parsed_content).to eq("0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59")
  end
  
  it "parses the number format" do
    formatter = described_class.new("15")
    expect(formatter.parsed_content).to eq("15")
  end
  
  it "allows minute 0" do
    formatter = described_class.new("0")
    expect(formatter.parsed_content).to eq("0")
  end
  
  it "returns an error when the number is outside the minute range" do
    formatter = described_class.new("60")
    formatter.parsed_content
    expect(formatter.errors).to include("FormatError for minute field: Minute has to be either '*', a number between 0..59, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'")
  end

  it "parses the */15 format" do
    formatter = described_class.new("*/13")
    expect(formatter.parsed_content).to eq("0 13 26 39 52")
  end
  
  it "returns an error when the interval is outside the range" do
    formatter = described_class.new("*/60")
    formatter.parsed_content
    expect(formatter.errors).to include("FormatError for minute field: Minute has to be either '*', a number between 0..59, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'")
  end
  
  it "parses a range" do
    formatter = described_class.new("1-5")
    expect(formatter.parsed_content).to eq("1 2 3 4 5")
  end

  it "raises an error when the range is not consecutive" do
    formatter = described_class.new("11-1")
    expect(formatter.errors).to include("FormatError for minute field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5")
  end


  it "raises error when range is badly defined" do
    formatter = described_class.new("1-66")
    expect(formatter.errors).to include("FormatError for minute field: Minute has to be either '*', a number between 0..59, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'")
  end
  
  it "parses a comma separated list" do
    formatter = described_class.new("0,10,15,25,30")
    expect(formatter.parsed_content).to eq("0 10 15 25 30")
  end
  
  it "raises an error when the comma separated list is out of range" do
    formatter = described_class.new("0,10,15,25,66")
    expect(formatter.errors).to include("FormatError for minute field: Minute has to be either '*', a number between 0..59, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'")
  end

  it "raises an error when the comma separated list is badly formatted" do
    formatter = described_class.new("0, 10,15, 25,")
    expect(formatter.errors).to include("FormatError for minute field: Minute has to be either '*', a number between 0..59, an interval '*/15' where 15 is the minute, a range 1-15, or a list of minutes '1,15,25,59'")
  end

  it "raises an error when the comma separated list is not consecutive" do
    formatter = described_class.new("0,55,15,25")
    expect(formatter.errors).to include("FormatError for minute field: Comma separated list needs to be consecutive")
  end
end
