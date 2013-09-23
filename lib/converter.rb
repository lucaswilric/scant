class Converter
  def initialize(factory)
    @factory = factory
  end

  def tiff_to_jpeg(from_filename, to_filename)
    run_command('convert', from_filename, to_filename)
  end

  def pnm_to_pdf(from_filename, to_filename)
    temp_file = "#{from_filename}.ps"

    pnm_to_ps(from_filename, temp_file)

    ps_to_pdf(temp_file, to_filename)
  end

  def pnm_to_ps(from_filename, to_filename)
    File.open(to_filename, 'w') do |f|
      f.write run_command('pnmtops', from_filename).stdout
    end
  end

  def ps_to_pdf(from_filename, to_filename)
    run_command('ps2pdf', from_filename, to_filename)
  end

  private

  def run_command(*args)
    result = @factory.pvc(*args).run

    raise "Conversion error (#{result.code})" if result.code > 0

    result
  end
end
