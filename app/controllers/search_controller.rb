class SearchController < ApplicationController
  before_action :authenticate_user!
  before_action :run_query, only: %i[ show ]

  def show
    render 'searches/show'  # this should be automatic?
  end

  private

  def run_query
    @results = {
      pins: Pin.kinda_spelled_like(params[:query]) + Pin.filter_by_tag(params[:query]),
      boards: Board.kinda_spelled_like(params[:query]),
      users: User.kinda_spelled_like(params[:query])
    }
  end

  def search_params
    params.require(:query)
  end

end