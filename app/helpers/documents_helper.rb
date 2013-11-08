module DocumentsHelper
  def get_scan_name
    Time.now.strftime('%Y%m%d%H%M%S')
  end
end
