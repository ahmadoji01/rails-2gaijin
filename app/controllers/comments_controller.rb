class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :authorized_user, except: [:create, :update, :destroy]
  invisible_captcha only: [:create]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)
    @product = Product.find(params[:comment][:product_id])

    @comment.user = current_user
    @comment.product = @product
    @comment.created_at = DateTime.now

    respond_to do |format|
      if @comment.save
        if @product.user.id != @comment.user.id
          if !@product.followers.include?(@comment.user)
            @product.followers << @comment.user
            @product.update
          end

          @notification = Notification.create name: current_user.first_name + " commented on your " + @product.name,
                                              created_at: DateTime.now,
                                              user: @product.user,
                                              product: @product,
                                              comment: @comment,
                                              status: :unread,
                                              type: :comment,
                                              orderer: @comment.user

          NewsletterMailer.new_product_comment_later(@product.user.id.to_s, @comment.user.id.to_s, @product.id.to_s).deliver_later(wait: 10.seconds)
          @product.user.update_attribute :notif_read, false
          broadcast_notif(@notification, @product.user, "Add")
        end

        if @product.user.id == @comment.user.id
          @product.followers.each do |follower|
            @notification = Notification.create name: @product.user.first_name + " commented on their " + @product.name,
                                                created_at: DateTime.now,
                                                user: follower,
                                                product: @product,
                                                comment: @comment,
                                                status: :unread,
                                                type: :comment,
                                                orderer: @product.user
            
            NewsletterMailer.new_product_comment_later(follower.id.to_s, @product.user.id.to_s, @product.id.to_s).deliver_later(wait: 10.seconds)
            follower.update_attribute :notif_read, false 
            broadcast_notif(@notification, follower, "Add")
          end
        end

        format.html { redirect_to @product, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @notification = Notification.where(comment_id: @comment.id)

    if @notification.present?
      @notification = @notification.first
      @notification.destroy
      broadcast_notif(@notification, @notification.product.user, "Delete")
    end

    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @comment.product, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  protected

    def count_unread_notifs(user)
      Notification.where(:status_cd => 0).and(:user_id => user.id).length
    end

    def broadcast_notif(notification, user, action)

      avatar_image_url = ""

      if notification.orderer.present?
        if notification.orderer.avatar.present?
          avatar_image_url = notification.orderer.avatar.thumb.url
        else
          avatar_image_url = ActionController::Base.helpers.image_url("avatar/avatar-1.png")
        end
      else
        avatar_image_url = ActionController::Base.helpers.image_url("avatar/avatar-1.png")
      end

      NotificationChannel.broadcast_to user, notification
      ActionCable.server.broadcast "notification_channel_#{user.id}", unreadnotifs: count_unread_notifs(user), 
                                                                      notifid: notification.id.to_s,
                                                                      name: notification.name, 
                                                                      link: product_path(notification.product, notification_id: notification.id),
                                                                      image_url: avatar_image_url,
                                                                      time: notification.created_at,
                                                                      action: action
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content, :product_id)
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
