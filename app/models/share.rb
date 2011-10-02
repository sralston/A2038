class Share < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :stock_owner, :polymorphic => true
	belongs_to :corporation
end
