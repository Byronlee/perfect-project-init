require 'spec_helper'

describe Users::SessionsController do
  include Rails.application.routes.url_helpers
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "GET 'new'" do
    context "online" do
      login_user
      before { get :new }
      it { should redirect_to(controller.after_sign_in_path_for(controller.current_user)) }
    end

    context "offline" do
      before { get :new }
      it { should redirect_to(user_omniauth_authorize_path(provider: :krypton)) }
    end
  end

  describe "DELETE 'destroy'" do
    context "with ok_url" do
      let(:ok_url) { "http://google.com" }
      before { delete :destroy, ok_url: ok_url }
      it { should redirect_to ok_url }
    end
    context "without ok_url" do
      before { delete :destroy }
      it { should redirect_to root_path }
    end
  end
end
