require 'spec_helper'
require 'ioc_rb'

describe IocRb::Container do

  module Test
    class Logger
      attr_accessor :appender
    end

    class Appender
    end
  end

  describe "#register" do
    let(:container) do
      container = IocRb::Container.new
      container.register(:appender, class: Test::Appender)
      container.register(:logger, class: Test::Logger) do
        attr :appender, ref: :appender
      end
      container
    end
    it "should register dependency" do
      container[:logger].should be_a(Test::Logger)
      container[:logger].appender.should be_a(Test::Appender)
    end

    it "should return the same instance on each call" do
      logger = container[:logger]
      container[:logger].should == logger
    end
  end
end
