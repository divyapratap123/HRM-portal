class NotificationsController < ApplicationController

  def index
    if params[:page].present?
      notification_messages = BxBlockNotifications::NotificationMessage.where(recipient_id: current_user.id).order(id: :desc).page(params[:page]).per(10)
    else
      notification_messages = BxBlockNotifications::NotificationMessage.where(recipient_id: current_user.id).order(id: :desc)
    end 
      render json: BxBlockNotifications::NotificationMessageSerializer.new(notification_messages, meta: { notification_count: BxBlockNotifications::NotificationMessage.where(recipient_id: current_user.id).not_readed.count, message: "List of notifications."}).serializable_hash, status: :ok 
  end

  def read_all_notificatons
    if params[:data].present? && params[:data][:ids].present?
      notification_messages = BxBlockNotifications::NotificationMessage.where(id: params[:data][:ids])
      notification_messages.update_all(is_read: true)
      render json: BxBlockNotifications::NotificationMessageSerializer.new(notification_messages.order(id: :desc), meta: {
                    message: "Success."}).serializable_hash, status: :ok
    else
      render json: {message: 'Something went wrong, please provide ids..!'}
    end
  end

  def show
    notification_messages = BxBlockNotifications::NotificationMessage.find(params[:id])
    notification_messages.update_column(:is_read, true)
    render json: BxBlockNotifications::NotificationMessageSerializer.new(notification_messages, meta: {
                  message: "Success."}).serializable_hash, status: :ok
  end


  def destroy
    notification = BxBlockNotifications::NotificationMessage.find(params[:id])
    if notification.update_column(:is_deleted, true)
      render json: {message: "Deleted Successfully."}, status: :ok
    else
      render json: {errors: format_activerecord_errors(notification.errors)},
             status: :unprocessable_entity
    end
  end

  private

  # def notification_paramas
  #   params.require(:notification).permit(
  #     :headings, :contents, :app_url, :account_id
  #   ).merge(created_by: @current_user.id)
  # end

  def format_activerecord_errors(errors)
    result = []
    errors.each do |attribute, error|
      result << { attribute => error }
    end
    result
  end
end
