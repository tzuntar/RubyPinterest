class PinsController < ApplicationController
  before_action :set_pin, only: %i[ show edit update destroy save_to_board ]
  before_action :set_local_pin, only: %i[ save unsave ]
  before_action :authenticate_user!
  #before_action :authorize_user, only: %i[edit update destroy]

  # GET /pins or /pins.json
  def index
    #@pins = current_user.recommended_pins
    user_feed = current_user.feed
    @pins = (if user_feed != nil then user_feed.pins else current_user.recommended_pins end)
  end

  # GET /pins/1 or /pins/1.json
  def show
    @similar = @pin.similar_pins
    @comments = @pin.comments
  end

  # GET /pins/new
  def new
    @pin = Pin.new
  end

  # GET /pins/1/edit
  def edit
    @tags_entry = @pin.tags.pluck(:name).join(', ')
  end

  # POST /pins/1/save
  def save
    current_user.bookmarks.create(pin: @pin)
    redirect_back(fallback_location: @pin)
  end

  # POST /pins/1/unsave
  def unsave
    current_user.bookmarks.where(pin: @pin).destroy_all
    redirect_back(fallback_location: @pin)
  end

  def save_to_board
    board = Board.find(params[:board_id])
    raise pin_params
    board.pins.push(@pin)
    board.pins.save
    redirect_back(fallback_location: @pin)
  end

  # POST /pins or /pins.json
  def create
    @pin = Pin.new(pin_params.except(:tags_entry))
    @pin.user = current_user
    pin_params[:tags_entry].split(',').each do |tag|
      @pin.tags.push(Tag.find_or_create_by(name: tag.strip.downcase))
    end

    respond_to do |format|
      if @pin.save
        format.html { redirect_to pin_url(@pin), notice: "Pin was successfully created." }
        format.json { render :show, status: :created, location: @pin }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pins/1 or /pins/1.json
  def update
    #@pin.tags.destroy_all
    @pin.tags = []
    pin_params[:tags_entry].split(',').each do |tag|
      @pin.tags.push(Tag.find_or_create_by(name: tag.strip.downcase))
    end

    respond_to do |format|
      if @pin.update(pin_params.except(:tags_entry))
        format.html { redirect_to pin_url(@pin), notice: "Pin was successfully updated." }
        format.json { render :show, status: :ok, location: @pin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pins/1 or /pins/1.json
  def destroy
    @pin.destroy

    respond_to do |format|
      format.html { redirect_to pins_url, notice: "Pin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /user/:id/boards
  def index_by_user
    @user = User.find(params[:user_id])
    @pins = @user.pins
  end

  def like
    @pin = Pin.find(params[:id])
    @pin.upvote_by current_user
    redirect_back fallback_location: root_path
  end

  def dislike
    @pin = Pin.find(params[:id])
    @pin.downvote_by current_user
    redirect_back fallback_location: root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    def set_local_pin
      @pin = Pin.find(params[:pin_id])
    end

    # Only allow a list of trusted parameters through.
    def pin_params
      params.require(:pin).permit(:title, :url, :description, :tags_entry, :board_id)
    end
end
