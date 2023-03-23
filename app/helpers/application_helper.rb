module ApplicationHelper

  def display_notice
    content_tag(:p, notice, class: 'notice') if notice.present?
  end

  def display_alert
    content_tag(:p, alert, class: 'alert') if alert.present?
  end

  def display_right_navbar
    if user_signed_in?
      render 'layouts/dropdown_options'
    else
      render 'layouts/login_buttons'
    end
  end

  def display_active_class(link_path)
    'active' if current_page?(link_path)
  end

end
