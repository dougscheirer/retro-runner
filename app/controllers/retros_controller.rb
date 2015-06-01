class RetrosController < ApplicationController
  before_action :set_retro, only: [:show, :edit, :update, :destroy]
  before_action :set_project
  skip_before_action :authenticate!, only: [ :index, :show ]
  before_action :admin_access?, only: [ :destroy ]

  # GET /retros
  # GET /retros.json
  def index
    @retros = Retro.where("project_id = #{params[:project_id]}").order("meeting_date DESC")
    puts @retros.size
  end

  # GET /retros/1
  # GET /retros/1.json
  def show
    redirect_to retro_issues_path(@retro)
  end

  # GET /retros/new
  def new
    @retro = Retro.new
    @retro.project_id = params[:project_id]
  end

  # GET /retros/1/edit
  def edit
  end

  # POST /retros
  # POST /retros.json
  def create
    @retro = Retro.new(retro_params)
    @retro.project_id = params[:project_id]
    @retro.status = "New"

    respond_to do |format|
      if @retro.save
        flash[:success] = "Retro #{@retro.id} was successfully created."
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @retro }
      else
        flash[:error] = @retro.errors
        format.html { render :new }
        format.json { render json: @retro.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retros/1
  # PATCH/PUT /retros/1.json
  def update
    respond_to do |format|
      if @retro.update(retro_params)
        flash[:success] = "Retro #{@retro.id} was successfully updated."
        format.html { redirect_to @retro }
        format.json { render :show, status: :ok, location: @retro }
      else
        flash[:error] = @retro.errors
        format.html { render :edit }
        format.json { render json: @retro.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retros/1
  # DELETE /retros/1.json
  def destroy
    @retro.destroy
    respond_to do |format|
      flash[:success] = "Retro #{@retro.id} was successfully destroyed."
      format.html { redirect_to project_retros_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retro
      @retro = Retro.find(params[:id])
    end

    def set_project
        @project = Project.find(params[:project_id] || @retro.project_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retro_params
      params.require(:retro).permit(:meeting_date, :project_id, :status)
    end
end
