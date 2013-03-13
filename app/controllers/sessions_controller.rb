class SessionsController < ApplicationController
    layout :determine_layout
    
    def index
        if params[:type] == "all" || params[:type].nil?
            @results = Project.search(params[:search])
            @results << Task.search(params[:search])
            if params[:user_related] == "0"
                @results << User.search(params[:search])
            end
        elsif params[:type] == "projects"
            @results = Project.search(params[:search])
            #@results = @results.users.where(:id => current_user.id)
        elsif params[:type] == "tasks"
            @results = Task.search(params[:search])
        elsif params[:type] == "users" && params[:user_related] == "0"
            @results = User.search(params[:search])
        else
            @results = []
        end
        @results = @results.flatten
        if params[:user_related] == "1"
        #    @results = @results.where(:user_ids => current_user.id)
            for result in @results
                if !result.users.index(current_user)
                    @results.delete(result)
                end
            end
        end
        if params[:type] == "all" || @results == 0
            @results += [current_user]
        end
        @results = @results.sort_by{ |page| page.name.downcase }
        @results = @results.paginate(:page => params[:page], :per_page => 10)
        respond_to do |format|
            format.html
        end
    end
    
    def new
    end
    
    def create
        user = User.find_by_email(params[:email])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect_to "/users", :notice => "Logged in!"
        else
            flash.now[:alert] = "Invalid email or password"
            render "new"
        end
    end
    
    def destroy
        reset_session
        redirect_to root_url, :notice => "Logged out!"
    end
    
    def calendar
        if params[:type] == "user"
            calendarType = User.find(params[:id])
        elsif params[:type] == "project"
            calendarType = Project.find(params[:id])
        end
        @tasks = calendarType.tasks
    end
    
    def forgot_password
    end
    
    def send_password
        user = User.find_by_email(params[:email])
        if !user.nil?
            UserMailer.forgot_password(user).deliver
            respond_to do |format|
                format.html {redirect_to "/forgot_password", notice: "A password reset request email has been sent to #{params[:email]}" }
            end
        else
            respond_to do |format|
                format.html {redirect_to "/forgot_password", notice: "Could no find an account registered to that email address" }
            end
        end
    end
    
    def confirm_code
        confirmation_code = params[:confirmation_code]
        users = User.all
        correct_user = nil
        for user in users
            if Digest::SHA2.hexdigest(user.id.to_s) == confirmation_code
                correct_user = user
                break
            end
        end
        if correct_user.nil? == false
            password = SecureRandom.hex(12)
            user.update_attributes(:password => password)
            UserMailer.send_new_password(user, password).deliver
        end
        redirect_to "/forgot_password", :notice => "password has been reset!"
    end
    
    private
      def determine_layout
        if ["calendar"].include?(action_name) || ["index"].include?(action_name)
          "application"
        else
          "public"
        end
      end
end
