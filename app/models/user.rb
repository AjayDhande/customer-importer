class User < ActiveRecord::Base

  validates :email, uniqueness: true
  validates :username, :email, presence: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # a class method import, with file passed through as an argument
  def self.user_import_csv(file)
  	logger = Logger.new("log/user_import.log")
    # a block that runs through a loop in our CSV data
    CSV.foreach(file.path, headers: true) do |row|
    	begin
    	  # creates a user for each row in the CSV file
        user = User.new row.to_hash
        if user.save
	        ApplicationMailer.welcome_email(user).deliver_later
	      end
			rescue StandardError => error
			  logger.info "Could not import row #{row} from #{file.original_filename} with error #{error}"
			end 
    end
  end 

  def self.user_import_spreadsheet(spreadsheet, header)
  	logger = Logger.new("log/user_import.log")
    # a block that runs through a loop in our CSV data
	  (2..spreadsheet.last_row).each do |i|
	    begin
		    row = Hash[[header, spreadsheet.row(i)].transpose]
    	  # creates a user for each row in the CSV file
        user = User.new row.to_hash
        if user.save
	        ApplicationMailer.welcome_email(user).deliver_later
	      end
			rescue StandardError => error
			  logger.info "Could not import row #{row} from #{file.original_filename} with error #{error}"
			end 
    end
  end 

  def self.importer_type(file)
  	return "please upload file" if file.nil?
  	file_type = File.extname(file.original_filename)
  	if file_type.eql?(".csv")
    	header = CSV.open(file.path, 'r') { |csv| csv.first }
	  	if header.include?("username")
	      User.user_import_csv(file)
	    elsif header.include?("address")
	    	Customer.customer_import_csv(file)
	    end
	    return "Data imported successfully"
  	elsif file_type.eql?(".xlsx")
      User.importer(file)
      return "Data imported successfully"
  	else
      return "Unknown file type: #{file.original_filename}"
    end
  end

  def self.importer(file)
	  spreadsheet = Roo::Spreadsheet.open(file.path)
	  header = spreadsheet.row(1)
	  if header.include?("username")
      User.user_import_spreadsheet(spreadsheet, header)
    elsif header.include?("address")
    	Customer.customer_import_spreadsheet(spreadsheet, header)
    end
  end
end
