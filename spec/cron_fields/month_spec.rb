require 'spec_helper'
require_relative '../../lib/cron_fields/field'
require_relative '../../lib/cron_fields/month'

describe CronFields::Month do
  context "when months are provided as numbers" do
    it "parses the * format" do
      formatter = described_class.new("*")
      expect(formatter.parsed_content).to eq("1 2 3 4 5 6 7 8 9 10 11 12")
    end

    it "parses the number format" do
      formatter = described_class.new("3")
      expect(formatter.parsed_content).to eq("3")
    end

    it "does not allow month 0" do
      formatter = described_class.new("0")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "returns an error when the number is outside the month range" do
      formatter = described_class.new("13")
      formatter.parsed_content
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "parses the */3 format" do
      formatter = described_class.new("*/3")
      expect(formatter.parsed_content).to eq("1 4 7 10")
    end

    it "returns an error when the interval is outside the range" do
      formatter = described_class.new("*/13")
      formatter.parsed_content
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "parses a range" do
      formatter = described_class.new("1-11")
      expect(formatter.parsed_content).to eq("1 2 3 4 5 6 7 8 9 10 11")
    end

    it "raises an error when the range is not consecutive" do
      formatter = described_class.new("11-1")
      expect(formatter.errors).to include("FormatError for month field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5")
    end

    it "raises error when range is badly defined" do
      formatter = described_class.new("1-66")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "parses a comma separated list" do
      formatter = described_class.new("1,3,6,9")
      expect(formatter.parsed_content).to eq("1 3 6 9")
    end

    it "raises an error when the comma separated list is out of range" do
      formatter = described_class.new("1,3,6,25,66")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "raises an error when the comma separated list is badly formatted" do
      formatter = described_class.new("1, 3,6, 9,")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "raises an error when the comma separated list is not consecutive" do
      formatter = described_class.new("1,9,3,6")
      expect(formatter.errors).to include("FormatError for month field: Comma separated list needs to be consecutive")
    end
  end
  
  context "when months are provided as names" do
    it "parses the month name" do
      formatter = described_class.new("Dec")
      expect(formatter.parsed_content).to eq("12")
    end

    it "parses the uppercase month name" do
      formatter = described_class.new("DEC")
      expect(formatter.parsed_content).to eq("12")
    end
    
    it "parses a range" do
      formatter = described_class.new("Jan-Mar")
      expect(formatter.parsed_content).to eq("1 2 3")
    end

    it "parses an uppercase range" do
      formatter = described_class.new("JAN-MAR")
      expect(formatter.parsed_content).to eq("1 2 3")
    end

    it "raises an error when the range is not consecutive" do
      formatter = described_class.new("Mar-Jan")
      expect(formatter.errors).to include("FormatError for month field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5")
    end

    it "raises error when range is badly defined" do
      formatter = described_class.new("Jan-Mon")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "parses a comma separated list" do
      formatter = described_class.new("Jan,Mar,Jun,Sep")
      expect(formatter.parsed_content).to eq("1 3 6 9")
    end

    it "raises an error when the comma separated list is out of range" do
      formatter = described_class.new("Jan,Mar,Jun,Sep,Mon")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "raises an error when the comma separated list is badly formatted" do
      formatter = described_class.new("Jan, Mar,Jun, Sep,")
      expect(formatter.errors).to include("FormatError for month field: Month has to be either '*', a number between 1..12, an interval '*/3' where 3 is the month, a range 1-3 or Jan-Mar, or a list of months '1,3,6,9' or 'Jan,Mar,Jun,Sep'")
    end

    it "raises an error when the comma separated list is not consecutive" do
      formatter = described_class.new("Jan,Sep,Mar,Jun")
      expect(formatter.errors).to include("FormatError for month field: Comma separated list needs to be consecutive")
    end
  end
end
