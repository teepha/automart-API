module DeleteRecordConcern
  extend ActiveSupport::Concern

  def delete_record(model, status, message, delete_success)
    return json_response({ error: Message.unauthorized }, 403) unless is_mine?(model) || is_admin?
    return json_response({ error: message }, 403) if check_status?(model, status) && !is_admin?
    model.update!(deleted_at: Time.now) if check_status?(model, status) && is_admin?
    json_response({ message: Message.delete_success(delete_success), data: model })
  end
end
