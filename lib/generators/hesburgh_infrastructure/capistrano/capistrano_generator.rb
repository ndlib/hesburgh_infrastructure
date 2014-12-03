require 'rails/generators'
require 'hesburgh_infrastructure'
module HesburghInfrastructure
  module Generators
    class CapistranoGenerator < ::Rails::Generators::Base

      desc <<DESC
Description:
    Copy default capistrano files
DESC

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def copy_lib
        directory "lib/hesburgh_infrastructure"
      end

      def capify
        copy_file "Capfile"
        template "config/deploy.rb.tt"
      end
    end
  end
end
