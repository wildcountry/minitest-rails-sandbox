require 'test_helper'

module Devise
  class SessionsControllerTest < ActionController::TestCase
    describe 'GET#new' do
      it 'sets up a new, empty user' do
        get :new
        user = assigns :user
        user.must_be_instance_of User
        user.must_be :new_record?
      end

      it 'renders the :new template' do
        get :new
        must_render_template :new
      end
    end

    describe 'POST#create' do
      describe 'with invalid attributes' do
        before do
          @user = create :user, password: 'Secret123'

          value do
            post :create, user: { email: @user.email, password: 'NotSecret456' }
          end.wont_change '@user.reload.sign_in_count'
        end

        it 'does not set the current-user in the session' do
          @controller.current_user.wont_be :present?
          session['warden.user.user.key'].wont_be :present?
        end

        it 'renders sessions#new' do
          must_render_template :new
        end

        it 'should not update signed-in information' do
          @user.reload.tap do |u|
            u.current_sign_in_at.must_be_nil
            u.current_sign_in_ip.must_be_nil
            u.sign_in_count.must_equal 0
          end
        end
      end

      describe 'with valid attributes' do
        before do
          Timecop.freeze Time.zone.now
          @user = create :user, password: 'Secret123'

          value do
            post :create, user: { email: @user.email, password: 'Secret123' }
          end.must_change '@user.reload.sign_in_count', +1
        end

        it 'sets the current-user in the session' do
          @controller.current_user.must_be :present?
          session['warden.user.user.key'].must_be :present?
        end

        it 'redirects to home#index' do
          must_redirect_to root_path
        end

        it 'should update signed-in information' do
          @user.reload
          @user.current_sign_in_at.to_i.must_equal Time.zone.now.to_i
          @user.current_sign_in_ip.must_be :present?
          @user.sign_in_count.must_equal 1
        end
      end

      it 'should strip leading/trailing spaces from email' do
        pass = 'Abce1234'
        create :user, email:  'john@example.com', password: pass

        post :create, user: { email:  ' john@example.com  ', password: pass }

        @controller.current_user.must_be :present?
        session['warden.user.user.key'].must_be :present?
      end

      describe 'unconfirmed access' do
        before do
          @password =  'Secret456'
          @user = create :unconfirmed_user, password: @password
          sign_out :user
        end

        it 'should not allow unconfirmed access immediately after sign-up' do
          # don't travel
        end

        it 'should not allow unconfirmed access after 0.5 days' do
          Timecop.travel(Time.zone.now + 0.5.days)
        end

        after do
          post :create, user: { email: @user.email, password: @password }
          flash.now[:alert].must_equal 'You have to confirm your email address before continuing.'
          session['warden.user.user.key'].wont_be :present?
        end
      end
    end

    describe 'POST#destroy' do
      it 'removes the user from the session' do
        sign_in create(:user)
        post :destroy

        @controller.current_user.must_be_nil
        session['warden.user.user.key'].must_be_nil

        must_redirect_to root_path
      end
    end
  end
end
