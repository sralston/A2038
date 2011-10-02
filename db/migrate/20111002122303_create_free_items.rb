class CreateFreeItems < ActiveRecord::Migration
  def self.up
    create_table :free_items do |t|
	  	t.references	:private_company
	  	t.string		:item_type, :limit=>6
      	t.timestamps	
    end
    add_index :free_items, :private_company_id
  end

  def self.down
    drop_table :free_items
  end
end
