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

  describe "bean definitions" do
    let(:container) do
      container = IocRb::Container.new
      container.bean(:appender, class: Test::Appender)
      container.bean(:logger, class: Test::Logger) do
        attr :appender, ref: :appender
      end
      container
    end
    it "should instanciate bean and it's dependencies" do
      container[:logger].should be_a(Test::Logger)
      container[:logger].appender.should be_a(Test::Appender)
    end

    it "container should return the same instance on each call" do
      logger = container[:logger]
      container[:logger].should == logger
    end
  end

  describe "passing bean definitions to container constructor" do
    let(:resource) do
      Proc.new do |c|
        c.bean(:appender, class: Test::Appender)
        c.bean(:logger, class: Test::Logger) do
          attr :appender, ref: :appender
        end
      end
    end

    it "should instanciate given bean definitions" do
      container = IocRb::Container.new([resource])
      container[:logger].should be_a(Test::Logger)
      container[:appender].should be_a(Test::Appender)
    end
  end

  describe "autowiring using :inject keyword" do
    module Test
      class ContactBook
        inject :contacts_repository
        inject :validator, ref: :contact_validator
      end

      class ContactsRepository
      end
      class ContactValidator
      end
      class ContactBuilder
      end
    end

    let(:container) do
      IocRb::Container.new do |c|
        c.bean(:contacts_repository, class: Test::ContactsRepository)
        c.bean(:contact_validator,   class: Test::ContactValidator)
        c.bean(:contact_book,        class: Test::ContactBook)
      end
    end

    it "should autowire dependencies" do
      container[:contact_book].contacts_repository.should be_a(Test::ContactsRepository)
      container[:contact_book].validator.should be_a(Test::ContactValidator)
    end
  end

  describe "inheritance" do
    module Test
      class Form
        inject :validator
      end

      class Circle < Form
        inject :circle_validator
      end
      class Rectangle < Form
        inject :rectangle_validator
      end

      class Validator
      end
      class CircleValidator
      end
      class RectangleValidator
      end
    end

    let(:container) do
      IocRb::Container.new do |c|
        c.bean(:circle,              class: Test::Circle)
        c.bean(:rectangle,           class: Test::Rectangle)
        c.bean(:validator,           class: Test::Validator)
        c.bean(:circle_validator,    class: Test::CircleValidator)
        c.bean(:rectangle_validator, class: Test::RectangleValidator)
      end
    end

    it "dependencies in subclasses shouldn't affect on each other" do
      container[:circle].circle_validator.should       be_a(Test::CircleValidator)
      container[:rectangle].rectangle_validator.should be_a(Test::RectangleValidator)
    end
  end

  describe "bean scopes" do
    module Test
      class ContactsService
        inject :contacts_repository
        inject :contacts_validator
      end
      class ContactsRepository
      end
      class ContactsValidator
      end
    end
    let(:container) do
      container = IocRb::Container.new
      container.bean(:contacts_repository, class: Test::ContactsRepository, scope: :request)
      container.bean(:contacts_service,    class: Test::ContactsService,    scope: :singleton)
      container.bean(:contacts_validator,  class: Test::ContactsValidator,  scope: :prototype)
      container
    end

    it "should instanciate bean with :request scope on each request" do
      first_repo  = container[:contacts_service].contacts_repository
      second_repo = container[:contacts_service].contacts_repository
      first_repo.should == second_repo
      RequestStore.clear! # new request
      third_repo  = container[:contacts_service].contacts_repository
      first_repo.should_not == third_repo
    end

    it "should instanciate bean with :prototype scope on each call" do
      first_validator  = container[:contacts_service].contacts_validator
      second_validator = container[:contacts_service].contacts_validator
      first_validator.should_not == second_validator
    end
  end
end
