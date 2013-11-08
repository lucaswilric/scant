class Factory
  def pvc(*args)
    PVC.new(*args)
  end

  def converter(*args)
    Converter.new(self, *args)
  end

  def scanner
    Scanner.new(Settings['SCANNER_NAME'])
  end
end
