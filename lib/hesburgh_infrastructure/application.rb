module HesburghInfrastructure
  class Application
    attr_accessor :name, :config

    def initialize(application_name)
      @name = application_name.to_s
      @config = self.class.applications[application_name.to_s]
      if @config.nil?
        raise ArgumentError, "#{application_name} not in list of applications.  Available applications: #{self.class.application_names.join(", ")}. New applications must be added to config/applications.yml in the hesburgh_infrastructure gem."
      end
    end

    def port_offset
      config["port_offset"]
    end

    def rails_root
      config["rails_root"]
    end

    def rails_root_prefix
      if rails_root
        "#{rails_root}/"
      else
        ""
      end
    end

    def rails_port
      3000 + port_offset
    end

    def rspec_port
      50000 + port_offset
    end

    def jetty_port
      8000 + port_offset
    end

    def self.applications
      @applications ||= HesburghInfrastructure.load_yml('applications.yml')
    end

    def self.application_names
      applications.keys.sort
    end
  end
end
