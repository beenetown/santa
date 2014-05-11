class StaticController < ApplicationController
  def home
    redirect_to current_user if signed_in?
  end

  def help
  end
end
