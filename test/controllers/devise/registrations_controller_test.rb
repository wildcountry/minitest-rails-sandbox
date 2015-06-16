require 'test_helper'

module Devise
  class RegistrationsControllerTest < ActionController::TestCase
    let(:attrs) { attributes_for :unconfirmed_user }

    describe 'GET#new' do
      it 'renders the :new template' do
        get :new
        must_render_template :new
      end
    end

    describe 'GET#edit' do
      it 'should authenticate the user' do
        # without sign-in
        get :edit
        must_redirect_to new_user_session_path
      end

      it 'renders the :edit template' do
        sign_in create(:user)
        get :edit
        must_render_template :edit
      end
    end

    describe 'POST#create' do
      describe 'with invalid attributes' do
        before do
          value do
            post :create, user: attrs.except(:full_name)
          end.wont_change 'User.count'
        end

        it 'does not create a new user' do
          # nothing extra to do
        end

        it 'renders new template' do
          must_render_template :new
        end

        it 'assigns the user error message' do
          error = assigns(:user).errors.messages[:full_name].first
          error.must_equal "can't be blank"
        end

        it 'sends no confirmation email' do
          ActionMailer::Base.deliveries.must_be :empty?
        end

        it 'does not sign in a user' do
          @controller.current_user.wont_be :present?
        end
      end

      describe 'duplicate email' do
        it 'should validate uniqueness of email' do
          create :user, attrs

          post :create, user: attrs

          error = assigns(:user).errors.messages[:email].first
          error.must_match(/already been taken/)
        end
      end

      describe 'with valid attributes' do
        before do
          value do
            post :create, user: attrs
          end.must_change 'User.count', 1
        end

        it 'adds the user' do
          # nothing extra to do
        end

        it 'encrypts the password' do
          u = assigns :user

          u.encrypted_password.wont_equal attrs[:password]
          u.encrypted_password.length.must_equal 60

          u.valid_password?(attrs[:password]).must_equal true
          u.valid_password?(u.encrypted_password).must_equal false
        end

        it 'redirects to home-page' do
          must_redirect_to root_path
        end

        ## Auto sign-in: Not currently enabled
        # it 'automatically sign-ins the new user' do
        #   @controller.current_user.must_be :present?
        #   session['warden.user.user.key'].must_be :present?
        # end

        it 'sets a flash message' do
          flash[:notice].must_match(/A message with a confirmation link/)
        end

        it 'sends a confirmation email' do
          mailbox_for(attrs[:email]).length.must_equal 1
          email = open_last_email_for attrs[:email]
          email.from.must_include 'minitest@example.com'
          email.subject.must_equal 'Confirmation instructions'
          email.body.to_s.must_match %r{href="http://www.example.com/users}
          email.from.must_include 'minitest@example.com'
          email.subject.must_equal 'Confirmation instructions'
          email.body.to_s.must_match %r{href="http://www.example.com/users}
        end
      end
    end
  end
end
