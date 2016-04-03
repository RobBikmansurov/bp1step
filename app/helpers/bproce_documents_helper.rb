module BproceDocumentsHelper
  def format_content(name)
    truncate(name, :length => 150, :omission => ' ...')
  end
end
