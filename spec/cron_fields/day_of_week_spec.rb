require 'spec_helper'
require_relative '../../lib/cron_fields/field'
require_relative '../../lib/cron_fields/day_of_week'

describe CronFields::DayOfWeek do
  context "when days are provided as numbers" do
    it "parses the * format" do
      formatter = described_class.new("*")
      expect(formatter.parsed_content).to eq("1 2 3 4 5 6 7")
    end
    
    it "parses the number format" do
      formatter = described_class.new("3")
      expect(formatter.parsed_content).to eq("3")
    end
    
    it "does not allow day 0" do
      formatter = described_class.new("0")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "returns an error when the number is outside the day of week range" do
      formatter = described_class.new("8")
      formatter.parsed_content
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "parses a range" do
      formatter = described_class.new("1-5")
      expect(formatter.parsed_content).to eq("1 2 3 4 5")
    end
    
    it "raises an error when the range is not consecutive" do
      formatter = described_class.new("5-1")
      expect(formatter.errors).to include("FormatError for dayofweek field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5")
    end
    
    it "raises error when range is badly defined" do
      formatter = described_class.new("1-66")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "parses a comma separated list" do
      formatter = described_class.new("1,2,3,4")
      expect(formatter.parsed_content).to eq("1 2 3 4")
    end
    
    it "raises an error when the comma separated list is out of range" do
      formatter = described_class.new("1,2,3,25,66")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "raises an error when the comma separated list is badly formatted" do
      formatter = described_class.new("1, 2,3, 4,")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "raises an error when the comma separated list is not consecutive" do
      formatter = described_class.new("1,4,3,2")
      expect(formatter.errors).to include("FormatError for dayofweek field: Comma separated list needs to be consecutive")
    end
  end
  
  context "when months are provided as names" do
    it "parses the month name" do
      formatter = described_class.new("Fri")
      expect(formatter.parsed_content).to eq("5")
    end
    
    it "parses the uppercase month name" do
      formatter = described_class.new("FRI")
      expect(formatter.parsed_content).to eq("5")
    end
    
    it "parses a range" do
      formatter = described_class.new("Mon-Fri")
      expect(formatter.parsed_content).to eq("1 2 3 4 5")
    end
    
    it "parses an uppercase range" do
      formatter = described_class.new("MON-FRI")
      expect(formatter.parsed_content).to eq("1 2 3 4 5")
    end
    
    it "raises an error when the range is not consecutive" do
      formatter = described_class.new("Fri-Mon")
      expect(formatter.errors).to include("FormatError for dayofweek field: Range has to have a start and an end, in ascending order, separated by a hyphen, e.g. 1-5")
    end
    
    it "raises error when range is badly defined" do
      formatter = described_class.new("Mon-Jan")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "parses a comma separated list" do
      formatter = described_class.new("Mon,Tue,Wed,Thu,Fri")
      expect(formatter.parsed_content).to eq("1 2 3 4 5")
    end
    
    it "raises an error when the comma separated list is out of range" do
      formatter = described_class.new("Mon,Tue,Jan")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "raises an error when the comma separated list is badly formatted" do
      formatter = described_class.new("Mon, Tue,Wed, Thu,")
      expect(formatter.errors).to include("FormatError for dayofweek field: Day of the week has to be either '*', a number between 1..12, a range 1-3 or Mon-Fri, or a list of days '1,3,6' or 'Mon,Wed,Sat'")
    end
    
    it "raises an error when the comma separated list is not consecutive" do
      formatter = described_class.new("Mon,Thu,Wed,Tue")
      expect(formatter.errors).to include("FormatError for dayofweek field: Comma separated list needs to be consecutive")
    end
  end
end
