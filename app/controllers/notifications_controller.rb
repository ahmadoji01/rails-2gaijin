class NotificationsController < ApplicationController
  before_action :set_notification, only: [:show, :edit, :update, :destroy]
  before_action :authorized_user, except: [:index, :create, :set_notif_read, :set_message_read, :update, :destroy]

  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = Notification.where(user_id: current_user.id).order(created_at: :desc)
    @notifications.each do |notification|
      if notification.unread?
        notification.update_attribute :status, :read
      end
    end
  end

  # GET /notifications/1
  # GET /notifications/1.json
  def show
  end

  # GET /notifications/new
  def new
    @notification = Notification.new
  end

  # GET /notifications/1/edit
  def edit
  end

  def set_notif_read
    if user_signed_in?
      if current_user.update_attribute :notif_read, true
        render json: "success".to_json
      else
        render json: "failed".to_json
      end
    end
  end

  def set_message_read
    if user_signed_in?
      if current_user.update_attribute :message_read, true
        render json: "success".to_json
      else
        render json: "failed".to_json
      end
    end
  end

  def email_subscription
    if params.her_key?(:email)
      user = User.find_by(email: params[:email])
      if user.receive_email?
        if current_user.update_attribute :receive_email, false
          sweetalert_success('You have successfully unsubscribed from email notification', 'Successfully Unsubscribed', button: 'Great!')
          redirect_to root_url
        else
          redirect_to root_url
        end
      else
        if current_user.update_attribute :receive_email, true
          sweetalert_success('You have successfully subscribed to email notification', 'Successfully Unsubscribed', button: 'Great!')
          redirect_to root_url
        else
          redirect_to root_url
        end
      end
    else
      redirect_to root_url
    end
  end

  # POST /notifications
  # POST /notifications.json
  def create
    @notification = Notification.new(notification_params)

    respond_to do |format|
      if @notification.save
        format.html { redirect_to @notification, notice: 'Notification was successfully created.' }
        format.json { render :show, status: :created, location: @notification }
      else
        format.html { render :new }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
    ActionCable.server.broadcast 'web_notifications_channel', notification: @notification.name, count: Notification.all.count
  end

  # PATCH/PUT /notifications/1
  # PATCH/PUT /notifications/1.json
  def update
    respond_to do |format|
      if @notification.update(notification_params)
        format.html { redirect_to @notification, notice: 'Notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @notification }
      else
        format.html { render :edit }
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:name)
    end

    def authorized_user
      if user_signed_in?
        if current_user.role != :admin
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
end
