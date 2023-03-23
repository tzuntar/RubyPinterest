class BoardsController < ApplicationController
  before_action :set_board, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  #before_action :authorize_user, only: %i[edit update destroy]

  # GET /boards or /boards.json
  def index
    @boards = Board.all
  end

  # GET /boards/1 or /boards/1.json
  def show
  end

  # GET /boards/new
  def new
    @board = current_user.boards.build
  end

  # GET /boards/1/edit
  def edit
  end

  # POST /boards or /boards.json
  def create
    @board = current_user.boards.build(board_params)

    respond_to do |format|
      if @board.save
        format.html { redirect_to board_url(@board), notice: "Board was successfully created." }
        format.json { render :show, status: :created, location: @board }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /boards/1 or /boards/1.json
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to board_url(@board), notice: "Board was successfully updated." }
        format.json { render :show, status: :ok, location: @board }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1 or /boards/1.json
  def destroy
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url, notice: "Board was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /user/:id/boards
  def index_by_user
    @user = User.find(params[:user_id])
    @boards = @user.boards
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = Board.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:title, :description)
    end
end
