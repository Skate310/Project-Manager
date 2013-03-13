class UsersController < ApplicationController
  layout :determine_layout
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.where(:completion => false)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.role = 1
    respond_to do |format|
      if @user.save
          session[:user_id] = @user.id
        format.html { redirect_to @user, :notice => 'User was successfully created.' }
        format.json { render :json => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
      @user = User.find(params[:id])
    
      if params[:commit] == "Update" || params[:commit] == "Change Password" && @user.authenticate(params[:password])
        respond_to do |format|
            if @user.update_attributes(params[:user])
                format.html { redirect_to @user, :notice => 'User was successfully updated.' }
                format.json { head :no_content }
            else
                if params[:commit] == "Update"
                    format.html { render :action => "edit" }
                    format.json { render :json => @user.errors, :status => :unprocessable_entity }
                elsif params[:commit] == "Change Password"
                    format.html { render action: "change_password" }
                    format.json { render json: @member.errors, status: unprocessable_entity }
                end
            end
        end
      else
          respond_to do |format|
              if params[:commit] == "Change Password"
                  format.html {redirect_to "/users/" + @user.id.to_s + "/change_password", notice: 'please enter the correct password' }
                  format.json { render json: @user.errors, status: unprocessable_entity }
              end
          end
      end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
    
  def change_password
    @user = User.find(current_user.id)
    respond_to do |format|
      format.html
      format.json { render json: @member }
    end
  end
    
  private
    def determine_layout
      if ["new"].include?(action_name)
        "public"
      else
        "application"
      end
    end
end
