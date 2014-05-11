module SessionsHelper
  def find_or_create_auth(uid, provider, name, email)
    auth = Auth.find_by(uid: uid, provider: provider)

    if auth
      user = auth.user 
      sign_in user
      flash[:notice] = "Welcome back #{user.view_name}!"
      redirect_to user
    else
      user = User.new()
      user.save!
      Auth.create(uid: uid, 
                  provider: provider, 
                  user_id: user.id, 
                  name: name,
                  email: email,
                  third_party: true)
      flash[:notice] = "Welcome to Secret Santa!"
      sign_in user
      redirect_to user
    end    
  end

  def add_auth_to_profile(uid, provider, name, email)
    auth = Auth.new(uid: uid, 
                    provider: provider, 
                    user_id: current_user.id, 
                    name: name,
                    email: email,
                    third_party: true)
    
    if auth.save 
      flash[:notice] = "#{provider.capitalize} was added to your profile!"
      redirect_to current_user
    else
      flash[:alert] = "Failed to add #{provider.capitalize} to your profile."
      redirect_to current_user
    end
  end

  def standard_sign_in(email, password)
    auth = Auth.find_by(email: email)
    user = auth.user if auth
    if auth && auth.authenticate(password)
      sign_in user
      flash[:notice] = "Welcome back #{user.view_name}!"
      redirect_to user
    else
      flash[:alert] = "Invalid email/password combination."
      redirect_to :back
    end
  end
end
