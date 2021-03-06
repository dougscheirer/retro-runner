require 'pusher'

Pusher.app_id = '133467'
Pusher.key = 'bec060895b93f6745a24'
Pusher.secret = 'd3e13b0e84b33a44613a'

class VotesController < ApplicationController
before_action :logged_in

  def new
    @vote = Vote.new
    @vote.user_id = current_user.id
    @vote.issue_id = params[:issue_id]
    @vote.retro_id = Retro.find(Issue.find(params[:issue_id]).retro_id)
  end

  def create
    @vote = Vote.new(vote_params)
    @vote.user_id = current_user.id
    @issue = Issue.find(params[:issue_id])
    @vote.retro_id = Retro.find(@issue.retro_id).id
    @retro = Retro.find(@vote.retro_id)
    respond_to do |format|
      if maxed_out < 3 && @vote.save
        @index = Issue.where("retro_id = #{@vote.retro_id} AND issue_type = '#{@issue.issue_type}'").order('votes_count DESC').index @issue
        format.html { redirect_to @retro }
        format.json { render json: {id: @issue.id, description: @issue.description } }
        Pusher.trigger('retro_channel', 'new-vote-event', @issue.id)
      else
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
      format.html { redirect_to @retro }
      format.json { head :no_content }
    end
  end

  def clear_all
    @votes = Vote.where(user_id: current_user.id, retro_id: params[:retro_id])
    @issue_ids = @votes.map { |vote| vote.issue_id }
    @votes.destroy_all
    respond_to do |format|
      format.html {redirect_to Retro.find(params[:retro_id])}
      format.json { head :no_content }
      Pusher.trigger('retro_channel', 'clear-votes-event', @issue_ids )
    end

  end

  private

  def vote_params
    params.permit(:issue_id)
  end

  def maxed_out
    @user_votes = Vote.where(user_id: current_user.id, retro_id: @retro.id)
    return @user_votes.count
  end

  def logged_in
    redirect_to login_path if current_user.nil?
  end
end