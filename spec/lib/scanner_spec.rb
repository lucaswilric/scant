require 'spec_helper'

describe Scanner do
  let (:scanner) { Scanner.new('foo') }

  it 'has a method "scan"' do
    Scanner.new('foo').respond_to?(:scan).should== true
  end

  describe 'scan' do
    let(:pvc) { PVC.new('') }
    let(:pvcf) { PVCFactory.new }

    after :each do
      File.delete 'bar.txt' if File.exist? 'bar.txt'
    end

    it 'should run a command' do
      pvcf.stub(:get_pvc) { pvc }
      pvc.should_receive(:run).and_return(PVC::Result.new(stdout: 'blah'))

      scanner.scan('bar.txt', { pvc_factory: pvcf })
    end
  end
end