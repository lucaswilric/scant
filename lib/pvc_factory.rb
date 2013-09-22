class PVCFactory
  def get_pvc(*args)
    PVC.new(*args)
  end
end