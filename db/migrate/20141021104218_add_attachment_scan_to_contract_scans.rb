class AddAttachmentScanToContractScans < ActiveRecord::Migration
  def self.up
    change_table :contract_scans do |t|
      t.attachment :scan
    end
  end

  def self.down
    remove_attachment :contract_scans, :scan
  end
end
