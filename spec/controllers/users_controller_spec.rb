require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  before :each do
	  @file = fixture_file_upload('files/customer (copy).xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
	end
  describe 'Get index' do
  	it 'render index page with customers' do
      get :index
      expect(response).to render_template("index")
    end
  end
  describe 'Post import' do
  	it 'Import uploaded file data' do
      post :import, params: { file: @file }
      response.successful?
    end
  end
end