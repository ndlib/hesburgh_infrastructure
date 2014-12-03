require 'rails/generators'
require 'hesburgh_infrastructure'
module HesburghInfrastructure
  module Generators
    class RspecSporkGenerator < ::Rails::Generators::Base

      desc <<DESC
Description:
    Create customized Rspec + Spork setup
DESC

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def copy_dot_rspec
        template '.rspec'
      end

      def copy_spec_files
        directory 'spec'
      end

      def remove_test
        if Rails.root
          test_dir = File.join(Rails.root, "test")
          if Dir.exists?(test_dir)
            default_test_files = ["fixtures", "fixtures/.gitkeep", "functional", "functional/.gitkeep", "integration", "integration/.gitkeep", "performance", "performance/browsing_test.rb", "test_helper.rb", "unit", "unit/.gitkeep"]
            default_test_files = default_test_files.collect{|f| File.join(test_dir, f)}
            current_test_files = Dir.glob(File.join(test_dir, "**", "{*,.[a-z]*}"))
            diff_files = current_test_files - default_test_files
            if diff_files.blank?
              puts "Removing empty test directories"
              if Dir.exists?(File.join(Rails.root, ".git"))
                git rm: "-rf test"
              end
              FileUtils.rm_rf(test_dir)
            end
          end
        end
      end

      def add_gems
        gem_group :development, :test do
          gem 'debugger'
          gem 'rspec-rails'
          gem 'capybara'
          gem 'factory_girl_rails', :require => false
          gem 'faker'
        end
      end
    end
  end
end
