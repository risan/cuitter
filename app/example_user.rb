class User
  attr_accessor :user, :email

  def initialize(attributes = {})
    @user = attributes[:user]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@user} <#{@email}>"
  end
end
