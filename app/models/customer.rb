require 'digest'
class Customer < ActiveRecord::Base
	attr_accessor	:password
	attr_accessible :name, :username, :email, :motto, :password, :password_confirmation
	
	email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates	:name, :presence => true, :length => { :maximum => 30 }
	validates	:username, :presence => true, :length => { :maximum => 15},
				:uniqueness => { :case_sensitive => false }
	validates	:email, :presence => true, :length => { :maximum => 120 },
				:format => { :with => email_regex }
	validates	:password, :presence => true, :length => { :within => 6..20 },
				:confirmation => true

	has_many :players
	has_many :games, :through => :players
	
	before_save :encrypt_password
	
	# returns true if the user's password matches the submitted password
	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end
	
	def self.authenticate(username, submitted_password)
		customer = find_by_username(username)
		return nil		if customer.nil?
		return customer	if customer.has_password?(submitted_password)
	end
	
	def self.authenticate_with_salt(id, cookie_salt)
		customer = find_by_id(id)
		(customer && customer.salt == cookie_salt) ? customer : nil
	end
	
	private
	
		def encrypt_password
			self.salt = make_salt if new_record?
			self.encrypted_password = encrypt(password)
		end
		
		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end
		
		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end
		
		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end
