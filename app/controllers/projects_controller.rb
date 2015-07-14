class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:edit, :update, :new]
  skip_before_action :authenticate!, only: [ :index, :show ]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.owner_id = current_user.id
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        flash[:success] = "Project #{@project.name} was successfully created."
        format.html { redirect_to project_retros_path(@project) }
        format.json { render :show, status: :created, location: @project }
      else
        flash[:error] = @project.errors
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        flash[:success] = "Project #{@project.name} was successfully updated."
        format.html { redirect_to root_path }
        format.json { render :show, status: :ok, location: @project }
      else
        flash[:error] = @project.errors
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      flash[:success] = "Project #{@project.name} was successfully destroyed."
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between outstandings.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_users
      @users = User.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :owner_id)
    end
end
