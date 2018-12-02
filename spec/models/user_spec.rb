require 'rails_helper'

RSpec.describe User do
	before :each do
	  @file_xlsx = fixture_file_upload('files/customer (copy).xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    @file_xls = fixture_file_upload('files/customer (copy).xls', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    @file_csv = fixture_file_upload('files/customer.csv', 'text/csv')
    @user_file_csv = fixture_file_upload('files/user.csv', 'text/csv')
    @user_file_xlsx = fixture_file_upload('files/user.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
	  @invalid_file = fixture_file_upload('files/importer.csv', 'text/csv')
	end
	it "does not allow email to be the same" do
    User.create(username: "username1", email: "abc@gmail.com")
    user = User.create(username: "username1", email: "abc@gmail.com")
    expect(user).to be_invalid
  end
	it "does not allow user without email" do
    user = User.create(username: "username1")
    expect(user).to be_invalid
  end
  it "does not allow user without username" do
    user = User.create(email: "abc@gmail.com")
    expect(user).to be_invalid
  end
  it "does not allow user with incorrect email" do
    user = User.create(email: "123", username: "username1")
    expect(user).to be_invalid
  end
  it "does not allow user with incorrect email" do
    user = User.create(email: "123@", username: "username1")
    expect(user).to be_invalid
  end
  it "does not allow user with incorrect email" do
    user = User.create(email: "123@gma", username: "username1")
    expect(user).to be_invalid
  end
  it "user should be created with correct username and email" do
    user = User.create(username: "username1", email: "abc@gmail.com")
    expect(user).to be_valid
  end
  describe "#importer_type" do
	  it "Import should run with xlsx file format" do
	    notice = User.importer_type(@file_xlsx)
	    expect(notice).to eql("Data imported successfully")
	  end
	  it "Import should run with csv file format" do
	    notice = User.importer_type(@file_csv)
	    expect(notice).to eql("Data imported successfully")
	  end
	  it "Import should not run with xls file format" do
	    notice = User.importer_type(@file_xls)
	    expect(notice).to eql("Unknown file type: customer (copy).xls")
	  end
	  it "Import should not run if file is not uploaded" do
	  	@file = nil
	    notice = User.importer_type(@file)
	    expect(notice).to eql("please upload file")
	  end
	  it "Customer should get created defined in CSV file" do
	  	customer_count = Customer.count
	    User.importer_type(@file_csv)
	    customer_count_result = Customer.count
	    expect(customer_count).to_not eql(customer_count_result)
	  end
	  it "Customer should be updated with country code and not country name" do
	    User.importer_type(@file_csv)
	    customer = Customer.find_by_name("Marry")
	    expect(customer.country_code).to eql("DK")
	  end
	  it "Customer should get created defined in XLSX file" do
	  	customer_count = Customer.count
	    User.importer_type(@file_xlsx)
	    customer_count_result = Customer.count
	    expect(customer_count).to_not eql(customer_count_result)
	  end
	  it "User should get created defined in CSV file" do
	  	user_count = User.count
	    User.importer_type(@user_file_csv)
	    user_count_result = User.count
	    expect(user_count).to_not eql(user_count_result)
	  end
	  it "User should get created defined in XLSX file" do
	  	user_count = User.count
	    User.importer_type(@user_file_xlsx)
	    user_count_result = User.count
	    expect(user_count).to_not eql(user_count_result)
	  end
	  it "User should not get created for invalid file" do
	  	user_count = User.count
	    User.importer_type(@invalid_file)
	    user_count_result = User.count
	    expect(user_count).to eql(user_count_result)
	  end
	  it "Customer should not get created for invalid file" do
	  	customer_count = Customer.count
	    User.importer_type(@invalid_file)
	    customer_count_result = Customer.count
	    expect(customer_count).to eql(customer_count_result)
	  end
	  it "Customer should not get created for file having user content" do
	  	customer_count = Customer.count
	    User.importer_type(@user_file_csv)
	    customer_count_result = Customer.count
	    expect(customer_count).to eql(customer_count_result)
	  end
	  it "User should not get created for file having customer content" do
	  	user_count = User.count
	    User.importer_type(@file_csv)
	    user_count_result = User.count
	    expect(user_count).to eql(user_count_result)
	  end
	  it 'sends an email' do
	  	user = User.create(username: "username1", email: "abc@gmail.com")
	    expect { ApplicationMailer.welcome_email(user).deliver }
	      .to change { ActionMailer::Base.deliveries.count }.by(1)
	  end
	end
end