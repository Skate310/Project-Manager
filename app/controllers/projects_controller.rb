class ProjectsController < ApplicationController
  layout :determine_layout
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    @tasks = @project.tasks
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new
    @users = User.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    @users = User.all
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, :notice => 'Project was successfully created.' }
        format.json { render :json => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, :notice => 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
    
  def budget
      @project = Project.find(params[:id])
      @tasks = @project.tasks
  end
    
  private
    def determine_layout
      if ["edit"].include?(action_name) || ["new"].include?(action_name) || ["budget"].include?(action_name)
        "admin"
      else
        "application"
      end
    end
end
