#  In order to use the app
#  As a citizen
#  I want to be able to register a new account and create a subscription
class UserRegistrationTest < ActionDispatch::IntegrationTest
  error_wrapper_css = 'div.input.field_with_errors'
  error_css = 'span.error'
  success_css = 'div.alert.alert-notice'
  register_button_text = 'Sign up'
  log_in_button_text = 'Log in'

  feature 'User Registration' do
    describe 'with invalid values' do
      before do
        visit new_user_registration_path
      end

      after do
        current_path.must_equal '/users'
        User.count.must_equal 0
        ActionMailer::Base.deliveries.must_be :empty?
      end

      scenario 'Attempt register with blank values' do
        click_button register_button_text

        %w(full_name email password).each do |field|
          css = "#{error_wrapper_css}.user_#{field}"
          page.must_have_css css

          within css do
            page.must_have_css error_css, text: %(can't be blank)
          end
        end
      end

      scenario 'Attempt register with invalid email format' do
        fill_in 'Email address', with: 'wibbble'
        click_button register_button_text
        errors = all "#{error_wrapper_css}.user_email #{error_css}",
                     text: 'invalid'

        errors.length.must_equal 1
      end

      scenario 'Attempt register with mismatched password confirmation' do
        fill_in 'Password', with: 'aaaaaa', match: :first
        fill_in 'Password confirmation', with: 'bbbbbb'
        click_button register_button_text

        errors = all "#{error_wrapper_css}.user_password_confirmation #{error_css}",
                     text: "doesn't match Password"

        errors.length.must_equal 1
      end

      scenario 'Attempt register with password that is too short' do
        fill_in 'Password', with: '123', match: :first
        fill_in 'Password confirmation', with: '123'
        click_button register_button_text

        errors = all "#{error_wrapper_css}.user_password #{error_css}",
                     text: 'is too short (minimum is 8 characters)'

        errors.length.must_equal 1
      end

      scenario 'Attempt register with password that is too long' do
        fill_in 'Password', with: ('a' * 73), match: :first
        fill_in 'Password confirmation', with: ('a' * 73)

        click_button register_button_text

        errors = all "#{error_wrapper_css}.user_password #{error_css}",
                     text: 'is too long (maximum is 72 characters)'

        errors.length.must_equal 1
      end
    end

    [:rack_test, :poltergeist].each do |driver|
      describe "with valid values (driver: #{driver})" do
        let :attrs do
          uniq = Time.zone.now.to_f

          {
            email: "davy.jones#{uniq}@example.co.uk",
            password: 'abcdef123456',
            full_name: "Davy's Nursery"
          }
        end

        before do
          Capybara.current_driver = driver
          visit new_user_registration_path

          fill_in 'Full name', with: attrs[:full_name]
          fill_in 'Email', with: attrs[:email]
          fill_in 'Password', with: attrs[:password], match: :first
          fill_in 'Password confirmation', with: attrs[:password]

          expect { click_button register_button_text }.must_change 'User.count', +1
        end

        scenario 'Register and log-in (valid)' do
          page.must_have_css success_css, text: /A message with a confirmation link/

          mailbox_for(attrs[:email]).length.must_equal 1
          email = open_last_email_for attrs[:email]
          email.from.must_include 'minitest@example.com'
          email.subject.must_equal 'Confirmation instructions'
          email.body.to_s.must_match %r{href="http://www.example.com/users}

          User.count.must_equal 1
          user = User.last
          user.email.must_equal attrs[:email]
          user.full_name.must_equal attrs[:full_name]
          user.encrypted_password.must_be :present?

          visit parse_email_for_anchor_text_link(email, 'Confirm my account')

          page.must_have_css success_css,
                             text: 'Your email address has been successfully confirmed.'

          fill_in 'Email', with: attrs[:email]
          fill_in 'Password', with: attrs[:password]

          _user = User.find_by email: attrs[:email]

          expect do
            click_button log_in_button_text
          end.must_change '_user.reload.sign_in_count', +1

          current_path.must_equal root_path
        end

        scenario 'Register and log-in (invalid password)' do
          email = open_last_email_for attrs[:email]
          click_first_link_in_email email

          _user = User.find_by email: attrs[:email]

          fill_in 'Email', with: attrs[:email]
          fill_in 'Password', with: 'xxxx'

          expect do
            click_button log_in_button_text
          end.wont_change '_user.reload.sign_in_count'

          current_path.must_equal new_user_session_path
        end
      end
    end
  end
end
