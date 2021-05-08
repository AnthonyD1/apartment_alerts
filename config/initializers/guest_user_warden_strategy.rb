Warden::Strategies.add(:guest_user) do
  def valid?
    session[:guest_user_id].present?
  end

  def authenticate!
    user = User.find_by(id: session[:guest_user_id])
    success!(user) if user.present?
  end
end
