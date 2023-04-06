class BookmarksController < ApplicationController
  before_action :authenticate_user!

  # GET /user/saved
  def index
    @pins = Pin.where(id: current_user.bookmarks.pluck(:pin_id))
  end

end
