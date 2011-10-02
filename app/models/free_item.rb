class FreeItem < ActiveRecord::Base
	attr_accessible #none
	
	belongs_to :private_company
	
end
