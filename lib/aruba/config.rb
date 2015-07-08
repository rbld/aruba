require 'contracts'
require 'aruba/basic_configuration'
require 'aruba/config_wrapper'
require 'aruba/hooks'
require 'aruba/contracts/relative_path'

module Aruba
  # Aruba Configuration
  class Configuration < BasicConfiguration
    option_reader   :root_directory, :contract => { None => String }, :default => Dir.getwd
    option_accessor :working_directory, :contract => { Aruba::Contracts::RelativePath => Aruba::Contracts::RelativePath }, :default => 'tmp/aruba'

    if RUBY_VERSION < '1.9'
      option_reader   :fixtures_path_prefix, :contract => { None => String }, :default => '%'
    else
      option_reader   :fixtures_path_prefix, :contract => { None => String }, :default => ?%
    end

    option_accessor :exit_timeout, :contract => { Num => Num }, :default => 15
    option_accessor :io_wait_timeout, :contract => { Num => Num }, :default => 0.1
    option_accessor :fixtures_directories, :contract => { Array => ArrayOf[String] }, :default => %w(features/fixtures spec/fixtures test/fixtures)
    option_accessor :command_runtime_environment, :contract => { Hash => Hash }, :default => ENV.to_hash
    option_accessor(:command_search_paths, :contract => { ArrayOf[String] => ArrayOf[String] }) { |config| [File.join(config.root_directory.value, 'bin')] }
  end
end

# Main Module
module Aruba
  @config = Configuration.new

  class << self
    attr_reader :config

    def configure(&block)
      @config.configure(&block)

      self
    end
  end
end

module Aruba
  # Old Config
  #
  # @private
  class Config < Configuration
    def initialize(*args)
      warn('The use of "Aruba::Config" is deprecated. Use "Aruba::Configuration" instead.')

      super
    end
  end
end
