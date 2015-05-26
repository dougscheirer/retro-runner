class RetrosController < ApplicationController
  before_action :set_retro, only: [:show, :edit, :update, :destroy]
  before_action :set_project

  # GET /retros
  # GET /retros.json
  def index
    @retros = Retro.where("project_id = #{params[:project_id]}")
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
  end

  # GET /retros/1/edit
  def edit
  end

  # POST /retros
  # POST /retros.json
  def create
    retro_param_object = retro_params
    @retro = Retro.new(retro_params)
    @retro.status = "New"
    # TODO: make this part of the path (nested resources in the routes file)
    @retro.project_id = 1

    respond_to do |format|
      if @retro.save
        format.html { redirect_to @retro, notice: 'Retro was successfully created.' }
        format.json { render :show, status: :created, location: @retro }
      else
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
        format.html { redirect_to @retro, notice: 'Retro was successfully updated.' }
        format.json { render :show, status: :ok, location: @retro }
      else
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
      format.html { redirect_to retros_url, notice: 'Retro was successfully destroyed.' }
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
