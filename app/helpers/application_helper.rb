module ApplicationHelper
  def user_avatar(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      asset_path 'avatar.webp'
    end
  end

  def word_decline(number, first_form, second_form, third_form)
    if (number % 100).between?(11, 14)
      return third_form
    else
      case number % 10
      when 1 then first_form
      when 2..4 then second_form
      else third_form
      end
    end
  end
end
