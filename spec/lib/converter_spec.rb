require 'spec_helper'

describe Converter do
  let(:factory) { Factory.new }
  let(:conv) { Converter.new(factory) }
  let(:pvc) { PVC.new('ruby', '-e', 'puts "foo bar baz"') }

  after :each do
    Dir.glob('bar.*').each do |f|
      File.delete(f)
    end
  end

  describe :tiff_to_jpeg do
    it 'runs `convert`' do
      factory.should_receive(:pvc).with('convert', 'bar.tiff', 'bar.jpg').and_return(pvc)

      conv.tiff_to_jpeg('bar.tiff', 'bar.jpg')
    end
  end

  describe :pnm_to_ps do
    it 'runs `pnmtops`' do
      factory.should_receive(:pvc).with('pnmtops', 'bar.pnm').and_return(pvc)

      conv.pnm_to_ps('bar.pnm', 'bar.ps')
    end
  end

  describe :ps_to_pdf do
    it 'runs `ps2pdf`' do
      factory.should_receive(:pvc).with('ps2pdf', 'bar.ps', 'bar.pdf').and_return(pvc)

      conv.ps_to_pdf('bar.ps', 'bar.pdf')
    end
  end
end
