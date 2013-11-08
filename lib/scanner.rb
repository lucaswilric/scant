class Scanner
  #
  # Talks to the scanner via the `scanimage` executable.
  # 
  # Formats:
  # - PDF
  # - TIFF
  # - JPG
  #
  # Color modes:
  # - Color
  # - Greyscale
  # 
  # Detail levels:
  # - Low: 100 pixels/inch
  # - Medium: 200 pixels/inch
  # - High: 400 pixels/inch
  #

  Defaults = {
    format: :jpg,
    detail: :medium,
    mode: :color
  }

  def initialize(name)
    @name = name
  end

  def scan(name, options = {})
    options = Defaults.merge options

    @factory = options.delete(:factory) || Factory.new

    args = get_args(options)

    temp_filename = "#{ name }.#{ args[:initial_format] }"
    filename = "#{ name }.#{ options[:format] }"
    perform_scan(filename, args)

    convert(options[:format], temp_filename, filename)

    filename
  end

  private

  def convert(format, from_filename, to_filename)
    # Nothing to do
    return if :tiff == format

    method = case format
      when :jpeg, :jpg then :tiff_to_jpeg
      when :pdf then :pnm_to_pdf
    end

    @factory.converter.public_send(method, from_filename, to_filename)
  end

  def get_args(options)
    {
      mode: 
        case options[:mode]
          when :color then 'Color'
          when :grey, :gray then 'Gray'
        end,

      initial_format: 
        case options[:format]
          when :jpg, :tiff then 'tiff'
          when :pdf then 'pnm'
        end,

      resolution: 
        case options[:detail]
          when :low then '100'
          when :medium then '200'
          when :high then '400'
        end
    }
  end

  def perform_scan(filename, args)
    command = "scanimage"
    params = [
      "-d", @name, 
      "--mode=#{ args[:mode] }", 
      "--format=#{ args[:initial_format] }",
      "--resolution=#{ args[:resolution] }", 
      "-l", "0",
      "-t", "0", 
      "-x", "1000",
      "-y", "1000"]

    File.open(filename, 'w+') do |f|
      f.write(@factory.pvc(command, *params).run.stdout)
    end
  end
end
