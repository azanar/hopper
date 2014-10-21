require 'stringio'

require 'pp'

require 'active_support'

module Hopper
  def self.logger
    return @logger if @logger

    @logger = Logger.new(STDOUT)
    @logger.formatter = Logger::Formatter.new

    @logger.formatter = proc { |severity, datetime, progname, msg| 
      "[#{datetime}, #{severity}] #{msg}\n"
    }
    @logger
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.env
    @_env ||= ActiveSupport::StringInquirer.new(ENV["HOPPER_ENV"] || ENV["RAILS_ENV"] || "development")
  end

  def self.env=(environment)
    @_env = ActiveSupport::StringInquirer.new(environment)
  end

  def self.ignore_redshift?
    Hopper.env.sandbox? or Hopper.env.staging?
  end
end

