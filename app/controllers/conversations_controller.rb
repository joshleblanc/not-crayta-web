class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[ show edit update destroy ]

  # GET /conversations or /conversations.json
  def index
    @conversations = policy_scope(Conversation.all.order(created_at: :desc))
  end

  # GET /conversations/1 or /conversations/1.json
  def show
  end

  # GET /conversations/new
  def new
    @conversation = Conversation.new
    authorize @conversation
  end

  # GET /conversations/1/edit
  def edit
  end

  # POST /conversations or /conversations.json
  def create
    @conversation = Conversation.new(conversation_params)
    @conversation.user = current_user

    authorize @conversation

    respond_to do |format|
      if @conversation.save
        format.html { redirect_to conversation_url(@conversation), notice: "Conversation was successfully created." }
        format.json { render :show, status: :created, location: @conversation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conversations/1 or /conversations/1.json
  def update
    respond_to do |format|
      if @conversation.update(conversation_params)
        format.html { redirect_to conversation_url(@conversation), notice: "Conversation was successfully updated." }
        format.json { render :show, status: :ok, location: @conversation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @conversation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conversations/1 or /conversations/1.json
  def destroy
    @conversation.destroy!

    respond_to do |format|
      format.html { redirect_to conversations_url, notice: "Conversation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conversation
      @conversation = Conversation.find(params[:id])
      authorize @conversation
    end

    # Only allow a list of trusted parameters through.
    def conversation_params
      params.require(:conversation).permit(:title, :send_baseline_prompt, :send_documentation, :send_project_code)
    end
end
