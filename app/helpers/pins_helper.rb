module PinsHelper

  def save_button(pin)
    if current_user.bookmarks.where(pin: pin).present?
      link_to 'Unsave', pin_unsave_path(pin), data: { turbo_method: :post }, class: 'btn btn-danger'
    else
      link_to 'Save', pin_save_path(pin), data: { turbo_method: :post }, class: 'btn btn-primary'
    end
  end

end
