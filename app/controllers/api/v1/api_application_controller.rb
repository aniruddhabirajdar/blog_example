class Api::V1::ApiApplicationController < ActionController::API
  before_action :current_user

  def current_user
    if (request.headers["token"])
      @current_user = User.find_by_id(request.headers["token"])
    else
      @current_user = User.get_guest_user
    end

    unless @current_user # To avoid this excution please seed the data frm seed.rb rake db: seed
      render json: { message: "User token required" }
    end
  end
end
