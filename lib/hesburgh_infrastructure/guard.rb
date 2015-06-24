module HesburghInfrastructure
  class Guard

    attr_reader :application, :guard_instance
    def initialize(application, guard_instance)
      @application = HesburghInfrastructure::Application.new(application)
      @guard_instance = guard_instance
    end

    def bundler(options = {})
      options = {
        gemspec: false
      }.merge(options)
      guard 'bundler' do
        watch('Gemfile')

        if options[:gemspec]
          watch(/^.+\.gemspec/)
        end

        if block_given?
          yield
        end
      end
    end

    def coffeescript(options = {})
      options = {
        input: 'app/assets/javascripts',
        noop: true
      }
      guard 'coffeescript', options do
        if block_given?
          yield
        end
      end
    end

    def rails(options = {})
      options = {
        port: application.rails_port,
        root: application.rails_root
      }.merge(options)

      guard 'rails', options do
        watch('Gemfile.lock')
        watch(%r{^#{application.rails_root_prefix}config/(?!locales/|routes[.]rb|environments/).*})
        watch("#{application.rails_root_prefix}config/environments/development.rb")
        watch(%r{^lib/.*})

        callback(:start_begin) { puts "\e]1;[G] #{File.basename(Dir.getwd)} :#{ options[:port] }\a" }

        if block_given?
          yield
        end
      end
    end

    def spork(options = {})
        options = {
            aggressive_kill: false,
            rspec_env:  { 'RAILS_ENV' => 'test' },
            rspec_port: application.rspec_port
        }.merge(options)

        guard 'spork', options do
            watch("#{application.rails_root_prefix}config/application.rb")
            watch("#{application.rails_root_prefix}config/environment.rb")
            watch(%r{^#{application.rails_root_prefix}config/environments/.+\.rb$})
            watch(%r{^#{application.rails_root_prefix}config/initializers/.+\.rb$})
            watch('Gemfile.lock')
            watch('spec/spec_helper.rb') { :rspec }
            watch(%r{^spec/support/(.+)\.rb$})

            if block_given?
                yield
            end
        end
    end

    def spring(options = {})
        options = {
            rspec_cli: '--color --deprecation-out log/rspec_deprecations.log'
        }.merge(options)

        guard 'spring', options do
            watch(%r{^spec/.+_spec\.rb$})
            # Don't run all specs when spec_helper changes
            # watch(%r{^spec/spec_helper\.rb$})                   { |m| 'spec' }
            watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
            watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
            watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
                %W(spec/routing/#{m[1]}_routing_spec.rb spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb spec/requests/#{m[1]}_spec.rb)
            end

            # Capybara features specs
            watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

            # Turnip features and steps
            watch(%r{^spec/acceptance/(.+)\.feature$})
            watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

            if block_given?
                yield
            end
        end
    end

    def rspec(options = {})
      options = {
        all_on_start: false,
        all_after_pass: false,
        cmd: "bundle exec rspec -f doc"
      }.merge(options)

      guard 'rspec', options do
        watch(%r{^spec/.+_spec\.rb$})
        watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
        # Don't run all specs when spec_helper changes
        # watch('spec/spec_helper.rb')  { "spec" }

        # Rails example
        watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
        watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
        watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
        # Don't run all specs when spec support files change
        # watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
        watch('config/routes.rb')                           { "spec/routing" }
        watch('app/controllers/application_controller.rb')  { "spec/controllers" }

        # Capybara features specs
        watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/features/#{m[1]}_spec.rb" }

        # Turnip features and steps
        watch(%r{^spec/acceptance/(.+)\.feature$})
        watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }

        if block_given?
          yield
        end
      end
    end

    private

      def guard(*args, &block)
        guard_instance.guard(*args, &block)
      end

      def watch(*args, &block)
        guard_instance.watch(*args, &block)
      end

      def callback(*args, &block)
        guard_instance.callback(*args, &block)
      end
  end
end
