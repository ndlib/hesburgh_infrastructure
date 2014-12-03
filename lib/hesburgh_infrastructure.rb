require 'hesburgh_infrastructure/application'
require 'hesburgh_infrastructure/guard'

module HesburghInfrastructure
  def self.root
    @root ||= File.expand_path(File.dirname(File.dirname(__FILE__)))
  end

  def self.load_yml(file)
    YAML.load_file(File.join(self.root, "config", file))
  end

  def self.application_name
    Rails.application.class.parent_name.to_s.underscore
  end
end
