class CommentsController < ApplicationController
  def create
    @pin=Pin.find(params[:pin_id])
    @comment = @pin.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to pin_url(@pin), notice: "comment was successfully created." }
        format.json { render :show, status: :created, location: @pin }
      else
        format.html { redirect_to pin_url(@pin), notice: "comment was not created." }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body)
  end

end
