module ApplicationHelper
  include Pagy::Frontend

  def check val
    val ? "✔" : "✘"
  end

  def tick val
    "✔" if val
  end

  def apply_notice
    msg = notice
    unless msg.blank?
      render "layouts/notification", msg: msg
    end
  end
end
