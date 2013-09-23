require 'spec_helper'

describe Scanner do
  let (:scanner) { Scanner.new('foo') }

  it 'has a method "scan"' do
    Scanner.new('foo').respond_to?(:scan).should== true
  end

  describe 'scan' do
    let(:pvc) { PVC.new('') }
    let(:factory) { Factory.new }
    let(:converter) { Converter.new(factory) }

    after :each do
      Dir.glob('bar.*').each do |f|
        File.delete(f) if File.exist?(f)
      end
    end

    it 'runs a command' do
      factory.stub(:pvc) { pvc }
      factory.stub(:converter) { converter }

      converter.stub(:tiff_to_jpeg)
      pvc.should_receive(:run).and_return(PVC::Result.new(stdout: 'blah'))

      scanner.scan('bar.txt', { factory: factory })
    end

    it 'calls the `tiff_to_jpeg` method when scanning to JPEG' do
      factory.stub(:pvc) { pvc }
      factory.stub(:converter) { converter }

      pvc.stub(:run).and_return(PVC::Result.new(stdout: 'blah'))
      
      converter.should_receive(:tiff_to_jpeg)

      scanner.scan('bar.txt', { format: :jpeg, factory: factory })
   end

    it 'calls the `pnm_to_pdf` method when scanning to PDF' do
      factory.stub(:pvc) { pvc }
      factory.stub(:converter) { converter }

      pvc.stub(:run).and_return(PVC::Result.new(stdout: 'blah'))
      
      converter.should_receive(:pnm_to_pdf)

      scanner.scan('bar.txt', { format: :pdf, factory: factory })
    end
  end
end
