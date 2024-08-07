class ConversationContentsController < ApplicationController
  before_action :set_conversation_content, only: %i[ show update edit destroy ]
  before_action :set_conversation, only: %i[index create new]

  # GET /conversation_contents or /conversation_contents.json
  def index
    @conversation_contents = @conversation.conversation_contents.order(created_at: :asc)
  end

  # GET /conversation_contents/1 or /conversation_contents/1.json
  def show
  end

  # GET /conversation_contents/new
  def new
    @conversation_content = ConversationContent.new
    @conversation_content.conversation = @conversation
    authorize @conversation_content
  end

  # GET /conversation_contents/1/edit
  def edit
  end

  # POST /conversation_contents or /conversation_contents.json
  def create
    @conversation_content = @conversation.send_message(conversation_content_params[:text])

    authorize @conversation_content

    respond_to do |format|
      if @conversation_content.save     
        
        ReceiveMessageJob.perform_later(@conversation)

        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation_content.conversation), notice: "Conversation content was successfully created."}
        format.json { render :show, status: :created, location: @conversation_content }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conversation_content.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @conversation_content.update(conversation_content_params)
        format.html { redirect_to conversation_content_url(@conversation_content), notice: "Conversation content was successfully updated." }
        format.json { render :show, status: :ok, location: @conversation_content }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conversation_content.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversation_contents/1 or /conversation_contents/1.json
  def destroy
    @conversation_content.destroy!

    respond_to do |format|
      format.html { redirect_to conversation_conversation_contents_url(@conversation_content.conversation), notice: "Conversation content was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation_content
      @conversation_content = ConversationContent.find(params[:id])
      authorize @conversation_content
    end

    def set_conversation
      @conversation = Conversation.find(params[:conversation_id])
      authorize @conversation
    end

    # Only allow a list of trusted parameters through.
    def conversation_content_params
      params.require(:conversation_content).permit(:text)
    end
end
