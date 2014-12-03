require 'rails/generators'
require 'hesburgh_infrastructure'
module HesburghInfrastructure
  module Generators
    class InstallGenerator < ::Rails::Generators::Base

      desc <<DESC
Description:
    Install Capistrano, Rspec + Spork, and Guard
DESC

      def self.source_root
        @source_root ||= File.expand_path(File.dirname(__FILE__))
      end

      def capistrano
        generate "hesburgh_infrastructure:capistrano"
      end

      def rspec
        generate "hesburgh_infrastructure:rspec_spork"
      end

      def guard
        generate "hesburgh_infrastructure:guard"
      end

      def final
        readme "README"
      end
    end
  end
end
