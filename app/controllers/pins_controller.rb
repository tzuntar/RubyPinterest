class PinsController < ApplicationController
  before_action :set_pin, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  #before_action :authorize_user, only: %i[edit update destroy]

  # GET /pins or /pins.json
  def index
    @pins = Pin.all
  end

  # GET /pins/1 or /pins/1.json
  def show
    @similar = Pin.similar_to_this @pin
  end

  # GET /pins/new
  def new
    @pin = Pin.new
  end

  # GET /pins/1/edit
  def edit
    @tags_entry = @pin.tags.pluck(:name).join(', ')
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pin
      @pin = Pin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pin_params
      params.require(:pin).permit(:title, :url, :description, :tags_entry)
    end
end
