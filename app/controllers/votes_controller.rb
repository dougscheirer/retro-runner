class VotesController < ApplicationController


  def new
    @vote = Vote.new
    @vote.member_id = @current_user.id
    @vote.issue_id = params[:issue_id]
  end

  def create
    @vote = Vote.new(vote_params)
    @vote.member_id = @current_user.id
    @retro = Retro.find(Issue.find(params[:issue_id]).retro_id)
    respond_to do |format|
      if @vote.save
        flash[:success] = "Vote #{@vote.id} was successfully created."
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @issue }
      else
        flash[:error] = "invalid vote"
      end
    end
  end

  def show
  end

  def destroy
    @vote.destroy
    respond_to do |format|
      flash[:success] = "Vote #{@vote.id} was successfully destroyed."
      format.html { redirect_to @retro }
      format.json { head :no_content }
    end
  end

  private

  def vote_params
    params.permit(:issue_id)
  end
end