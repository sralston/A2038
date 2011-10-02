class CreateFreeItems < ActiveRecord::Migration
  def self.up
    create_table :free_items do |t|
	  	t.references	:private_companies
	  	t.string		:type, :limit=>6
      	t.timestamps	
    end
  end

  def self.down
    drop_table :free_items
  end
end
