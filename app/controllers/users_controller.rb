class UsersController < ApplicationController
  def index
    @users = User.all
    @customers = Customer.all
  end

  def import
    notice = User.importer_type(params[:file])
    # after the import, redirect and let us know the method worked!
    redirect_to root_url, notice: notice
  end
end



