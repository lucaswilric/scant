require 'fileutils'

Settings = AppConfiguration.new 'config/defaults.yml'

FileUtils.mkdir_p(Settings.doc_root)
