class SettingsError < StandardError; end;

class Settings
  def self.[](key)
    @@defaults ||= YAML.load_file("#{Rails.root}/config/defaults.yml")

    if ENV.has_key?(key)
      ENV[key]
    elsif @@defaults.has_key?(key)
      @@defaults[key]
    else
      raise SettingsError.new "#{key} is not set and has no default."
    end
  end
end
