class VotesController < ApplicationController
before_action :logged_in

  def new
    @vote = Vote.new
    @vote.user_id = @current_user.id
    @vote.issue_id = params[:issue_id]
  end

  def create
    @vote = Vote.new(vote_params)
    @vote.user_id = current_user.id
    @issue = Issue.find(params[:issue_id])
    @retro = Retro.find(@issue.retro_id)
    respond_to do |format|
      if maxed_out < 3 && @vote.save
        flash[:success] = "Vote #{@vote.id} was successfully created."
        format.html { redirect_to @retro }
        format.json { render :show, status: :created, location: @issue }
      else
        flash[:error] = "invalid vote"
        format.html { redirect_to @retro }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
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

  def clear_all
    Vote.where(user_id: current_user.id).destroy_all
  end

  private

  def vote_params
    params.permit(:issue_id)
  end

  def maxed_out
    @issues = Issue.where("retro_id = #{@retro.id}")
    @vote_count = 0
    for index in 0...@issues.size
      @vote_count += @issues[index].votes.count(user_id: current_user.id)
    end
    return @vote_count
  end

  def logged_in
    redirect_to login_path if current_user.nil?
  end
end