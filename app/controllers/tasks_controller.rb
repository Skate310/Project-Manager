class TasksController < ApplicationController
  layout :determine_layout
  respond_to :html, :json
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.json
  def new
    @task = Task.new
    @users = User.all
    @projects = Project.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @users = User.all
    @projects = Project.all
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(params[:task])
    respond_to do |format|
      if @task.save
        if @task.project.spent_budget + @task.spent <= @task.project.budget
          @task.project.spent_budget += @task.spent
          @task.project.save
          format.html { redirect_to @task, :notice => 'Task was successfully created.' }
          format.json { render :json => @task, :status => :created, :location => @task }
        else
          @task.spent = 0
          format.html { render :action => "new", :notice => 'Budget higher than Project budget' }
            format.json { render :json => @task.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => "new" }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @users = User.all
    @projects = Project.all
    @task = Task.find(params[:id])
    saved_spent = @task.spent
    @task.project.spent_budget = @task.project.spent_budget.to_f - saved_spent
    @task.project.save
    respond_to do |format|
      if @task.update_attributes(params[:task])
          if @task.project.spent_budget.to_f + @task.spent.to_f <= @task.project.budget.to_f
              
              @task.project.spent_budget = @task.spent.to_f + @task.project.spent_budget.to_f
              @task.project.save
              format.html { redirect_to @task, :notice => 'Task was successfully updated.' }
              #format.html { respond_with @task, :notice => 'Task was successfully updated.' }
              format.json { head :no_content }
          else
              @task.project.spent_budget = @task.project.spent_budget.to_f + saved_spent
              @task.project.save
              @task.spent = saved_spent
              @task.save
              #format.html { render :action => "edit", :notice => 'Budget higher than Project budget' }
              #format.json { head :no_content }
              respond_with @task
          end
      else
        @task.project.spent_budget = @task.project.spent_budget.to_f + saved_spent
        @task.project.save
        format.html { render :action => "edit" }
        format.json { render :json => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.json { head :no_content }
    end
  end
    
  private
    def determine_layout
      if ["new"].include?(action_name)
        "admin"
      else
        "application"
      end
    end
end
