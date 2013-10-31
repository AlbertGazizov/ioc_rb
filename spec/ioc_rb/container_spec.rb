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

  describe "passing dependencies definitions to container constructor" do
    let(:resource) do
      Proc.new do |c|
        c.register(:appender, class: Test::Appender)
        c.register(:logger, class: Test::Logger) do
          attr :appender, ref: :appender
        end
      end
    end

    it "should parse external dependency definitions" do
      container = IocRb::Container.new([resource])
      container[:logger].should be_a(Test::Logger)
      container[:appender].should be_a(Test::Appender)
    end
  end

  describe "using autowiring with :inject key word" do
    module Test
      class ContactBook
        inject :contacts_repository
      end

      class ContactsRepository
      end
    end

    let(:container) do
      IocRb::Container.new do |c|
        c.register(:contacts_repository, class: Test::ContactsRepository)
        c.register(:contact_book, class: Test::ContactBook)
      end
    end

    it "should autowire dependencies" do
      container[:contact_book].contacts_repository.should be_a(Test::ContactsRepository)
    end
  end
end
