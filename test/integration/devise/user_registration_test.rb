#  In order to use the app
#  As a citizen
#  I want to be able to register a new account and create a subscription
class UserRegistrationTest < ActionDispatch::IntegrationTest
  error_input_selector = 'div.input.field_with_errors'

  feature 'User Registration' do
    context 'with invalid values' do
      after do
        current_path.must_equal '/users'
        User.count.must_equal 0
        ActionMailer::Base.deliveries.must_be :empty?
      end

      scenario 'Attempt register with blank values' do
        visit new_user_registration_path

        click_button 'Sign up'

        %w(full_name email password).each do |field|
          css = "#{error_input_selector}.user_#{field}"
          page.must_have_css css

          within css do
            page.must_have_css 'span.error', text: %(can't be blank)
          end
        end
      end

    #   scenario 'Attempt register with invalid email format' do
    #     fill_in 'Email', with: 'wibbble'
    #     click_button register_button_text
    #     all(error_sel, text: "must contain '@'").count.should == 1
    #   end
    #
    #   scenario 'Attempt register with invalid postcode' do
    #     fill_in 'Postcode', with: 'SK99 XXX'
    #     click_button register_button_text
    #
    #     text = 'must be a full valid UK postcode'
    #     all(error_sel, text: text).count.should == 1
    #   end
    #
    #   scenario 'Attempt register with mismatched password confirmation' do
    #     fill_in 'Password', with: 'aaaaaa', match: :first
    #     fill_in 'Password confirmation', with: 'bbbbbb'
    #     click_button register_button_text
    #
    #     all(error_sel, text: "doesn't match confirmation").count.should == 1
    #   end
    #
    #   scenario 'Attempt register with password that is too short' do
    #     fill_in 'Password', with: '123', match: :first
    #     fill_in 'Password confirmation', with: '123'
    #     click_button register_button_text
    #     all(error_sel, text: "is too short (minimum is 6 characters)").count.should == 1
    #   end
    #
    #   scenario 'Attempt register with password that is too long' do
    #     fill_in 'Password', with: 'a'*129, match: :first
    #     fill_in 'Password confirmation', with: 'a'*129
    #
    #     click_button register_button_text
    #
    #     all(error_sel, text: "is too long (maximum is 128 characters)").count.should == 1
    #   end
    end
    #
    # context 'with valid values' do
    #   background do
    #     # create special 'The GPS Team' user
    #     create(:user, profile_name: 'the-gps-team', display_name: 'The GPS Team', postcode: 'N5 2JE')
    #
    #     uniq = Time.now.to_f
    #     @reg = {
    #       email: "davy.jones#{uniq}@greenplantswap.co.uk", password: 'abcdef123456',
    #       postcode: 'BS1 6QS',
    #       display_name: "Davy's Nursery"
    #     }
    #
    #     fill_in 'Email', with: @reg[:email]
    #     fill_in 'Personal or business name', with: @reg[:display_name]
    #     fill_in 'Password', with: @reg[:password], match: :first
    #     fill_in 'Password confirmation', with: @reg[:password]
    #     fill_in 'Postcode', with: @reg[:postcode]
    #
    #     click_button register_button_text
    #
    #     page.should have_css(success_sel, text: "An email confirmation has been sent to '#{@reg[:email]}'. Please open the link to activate your account.")
    #
    #     mailbox_for(@reg[:email]).length.should == 1
    #     open_last_email_for @reg[:email]
    #     visit_in_email 'here'
    #   end
    #
    #   [false, true].each do |js_enabled|
    #     context "javascript: #{js_enabled}", js: js_enabled do
    #       scenario 'default' do
    #         User.count.should == 2 # Including "The GPS Team" user
    #         user = User.order(:id).last
    #         user.email.should == @reg[:email]
    #         user.display_name.should == @reg[:display_name]
    #         user.encrypted_password.should be_present
    #         user.postcode.should == @reg[:postcode]
    #         user.created_source.should == 'main'
    #
    #         user.created_browser_user_agent.should == 'Rails Capybara Testing'
    #
    #         sel = '.alert-box.success'
    #         page.should have_css(sel, text: 'Your email address has been successfully confirmed.')
    #       end
    #     end
    #   end
    #
    #   scenario "email confirmation sent" do
    #     email = mailbox_for(@reg[:email]).first
    #     email.should be
    #     email.from.should include 'no-reply@greenplantswap.co.uk'
    #     email.subject.should == 'Please confirm your email address'
    #     email.should have_body_text(%r{href="https://test.greenplantswap.co.uk/users})
    #   end
    #
    #   scenario "welcome message (and message email notification) sent, after confirmation" do
    #     Conversation.count.should == 1
    #     msg = Message.first
    #     msg.subject.should == 'Welcome - We are here to help'
    #     msg.body.should include("Great to see you join GreenPlantSwap.")
    #     msg.conversation.category.should == 'welcome'
    #
    #     mailbox_for(@reg[:email]).length.should == 2
    #     email = open_last_email_for @reg[:email]
    #     email.from.should include 'no-reply@greenplantswap.co.uk'
    #     email.subject.should == 'Welcome - We are here to help'
    #     email.should have_body_text("You have received a new message from a #{I18n.t :site_name} member")
    #   end
    #
    #   scenario 'Register and log-in (valid)' do
    #     fill_in 'Email', with: @reg[:email]
    #     fill_in 'Password', with: @reg[:password]
    #     click_button 'Log in'
    #
    #     page.should have_no_css('#site_toolbar a', text: 'Log in')
    #     page.should have_css('#site_toolbar a', text: @reg[:display_name])
    #
    #     # page.should have_no_css('.top-bar a', text: 'Log in')
    #     # page.should have_css('.top-bar a', text: @reg[:display_name])
    #
    #     current_path.should == root_path
    #
    #     page.text.should match(/Welcome Aboard/i)
    #   end
    #
    #   scenario 'Register and log-in (invalid password)' do
    #     fill_in 'Email', with: @reg[:email]
    #     fill_in 'Password', with: 'xxxx'
    #     click_button 'Log in'
    #
    #     page.should have_css('.top-bar a', text: 'Log in')
    #     page.should have_no_css('.top-bar a', text: @reg[:display_name])
    #
    #     current_path.should == main_app.new_user_session_path
    #   end
    # end
  end
end
