class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_message, only: %i[show edit update destroy]

  def create
    @message = current_user.messages.create(content: message_param[:content], room_id: params[:room_id])
  end

  # PATCH/PUT /messages/1 or /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_param)
        format.html { redirect_to message_url(@message), notice: 'message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1 or /messages/1.json
  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_message
    @message = Message.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def message_param
    params.require(:message).permit(:content)
  end
end
