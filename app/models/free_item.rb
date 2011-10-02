class FreeItem < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :private_company
	belongs_to :corporation, :through => :private_company
	
end
