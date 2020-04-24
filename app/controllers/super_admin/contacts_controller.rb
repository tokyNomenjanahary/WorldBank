class SuperAdmin::ContactsController < ApplicationController
	before_action :authenticate_user!
  def index
    @messages = Message.all
  end

  def show
  	@message = Message.find(params[:id])
  end

  def update
  	@message = Message.find(params[:id])
  	if paramsMessage == 'Marquer comme lu'
  		@message.update(read: true)
  	elsif paramsMessage == 'Marquer comme non lu'
  		@message.update(read: nil)
  	end
  	redirect_to super_admin_contacts_path
  end


  private 
  def paramsMessage
  	params[:read]
  end
end