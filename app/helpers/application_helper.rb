module ApplicationHelper
  include Pagy::Frontend

  def check val
    val ? "✔" : "✘"
  end

  def tick val
    "✔" if val
  end
end
