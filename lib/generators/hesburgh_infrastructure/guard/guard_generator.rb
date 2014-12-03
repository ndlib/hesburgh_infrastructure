require 'rails/generators'
require 'hesburgh_infrastructure'
module HesburghInfrastructure
  module Generators
    class GuardGenerator < ::Rails::Generators::Base

      desc <<DESC
Description:
    Create customized Guard setup
DESC

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def create_guardfile
        template 'Guardfile.tt'
      end

      def add_gems
        gem_group :development, :test do
          gem 'guard', '~> 2.7.3'
          gem 'guard-bundler'
          gem 'guard-coffeescript'
          gem 'guard-rails'
          gem 'guard-rspec'
          gem 'guard-spork'
          gem 'rb-readline'
          gem 'growl'
        end
      end
    end
  end
end
