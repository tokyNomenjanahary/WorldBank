class SuperAdmin::ActusController < ApplicationController
  before_action :authenticate_user!

  def create

      @user = User.where(is_super_admin: true)
      @actu = Actu.create!(title: params[:title], user_id: current_user.id)

      if @actu.save
       @actu.files.attach(params[:files])
       redirect_to super_admin_actus_path
     else
       render :new

     end  

 end

def index
  @actus = Actu.all
end

 def show
   @actu = Actu.find(params[:id])
 end

 def edit
   @actu = Actu.find(params[:id])
 end

def update
    @actu = Actu.find(params[:id])
    if @actu.update(title: params[:id], user_id: current_user.id)
     redirect_to super_admin_actus_path
   end
end

def destroy
  @actu = Actu.find(params[:id])
  @actu.destroy
  redirect_to super_admin_actus_path
end

end
