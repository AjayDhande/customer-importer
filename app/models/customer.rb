class Customer < ActiveRecord::Base

  def self.customer_import_csv(file)
    # a block that runs through a loop in our CSV data
  	logger = Logger.new("log/customer_import.log")
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
    	begin
    	  # creates a user for each row in the CSV file
        customer = row.to_hash
        country_code = Customer.get_code(customer["country"])
        customer["country_code"] = country_code
        Customer.create! customer.except!("country")
			rescue StandardError => error
			  logger.info "Could not import row #{row} from #{file.original_filename} with error #{error}"
			end 
    end
  end
  
  def self.customer_import_spreadsheet(spreadsheet, header)
  	logger = Logger.new("log/customer_import.log")
	  (2..spreadsheet.last_row).each do |i|
	    begin
		    row = Hash[[header, spreadsheet.row(i)].transpose]
		    customer = row.to_hash
	      country_code = Customer.get_code(customer["country"])
	      customer["country_code"] = country_code
		    customer = Customer.new customer.except!("country")
		    customer.save!
		  rescue StandardError => error
			  logger.info "Could not import row #{row} from #{file.original_filename} with error #{error}"
			end
	  end
  end

  def self.get_code(country)
  	NormalizeCountry.convert(country, :to => :alpha2)
	end

end
