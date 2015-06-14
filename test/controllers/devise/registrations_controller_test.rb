# describe CustomRegistrationsController do
#   plan_codes =  %w(green blue yellow)
#
#   let(:attrs) { attributes_for(:unconfirmed_user).merge({postcode: 'SK12 1RR'}) }
#
#   describe 'GET#new' do
#     it "renders the :new template" do
#       get :new
#       response.should render_template(:new)
#     end
#   end
#
#   describe 'GET#edit' do
#     it 'should authenticate the user' do
#       # without sign-in
#       get :edit
#       response.should redirect_to(new_user_session_path)
#     end
#
#     it "renders the :edit template" do
#       sign_in create(:user)
#       get :edit
#       response.should render_template(:edit)
#     end
#   end
#
#   describe 'POST#create' do
#     context "with invalid attributes" do
#       before :each do
#         expect {
#           post :create, user: attrs.except(:display_name)
#         }.to_not change(User, :count)
#       end
#
#       it 'does not create a new user' do
#         # nothing extra to do
#       end
#
#       it 'renders new template' do
#         response.should render_template(:new)
#       end
#
#       it 'assigns the user error message' do
#         assigns(:user).errors.messages[:display_name].first.should == %(can't be blank)
#       end
#
#       it "sends no confirmation email" do
#         mailbox_for(attrs[:email]).should be_empty
#       end
#
#       it 'does not sign in a user' do
#         controller.current_user.should_not be_present
#       end
#
#    end
#
#    context 'duplicate email' do
#       it 'should validate uniqueness of email' do
#         create :user, attrs
#
#         post :create, user: attrs, plan: plan_codes.first
#         assigns(:user).errors.messages[:email].first.should match /already taken/
#       end
#
#       it 'should validate uniqueness of email (even when user is disabled)' do
#         create :user, attrs.merge({ disabled: true })
#
#         post :create, user: attrs, plan: plan_codes.first
#         assigns(:user).errors.messages[:email].first.should match /already taken/
#       end
#     end
#
#     context "with valid attributes" do
#       before :each do
#         expect { post :create, user: attrs, plan: plan_codes.first }.to change(User, :count).by(1)
#       end
#
#       it "adds the user" do
#         # nothing extra to do
#       end
#
#
#       it "encrypts the password" do
#         u = assigns(:user)
#         expect(u.encrypted_password).not_to eq attrs[:password]
#         expect(u.encrypted_password.length).to be > 50
#         expect(u.valid_password? attrs[:password]).to be true
#         expect(u.valid_password? u.encrypted_password).to be false
#       end
#
#       it "redirects to subscriptions#new" do
#         response.should redirect_to(root_path)
#       end
#
#       ## Auto sign-in: Not currently enabled
#       # it 'automatically sign-ins the new user' do
#       #   controller.current_user.should be_present
#       #   session['warden.user.user.key'].should be_present
#       # end
#
#       it 'sets a flash message' do
#         flash[:notice].should == %[An email confirmation has been sent to '#{attrs[:email]}'. Please open the link to activate your account.]
#       end
#
#       it "sends a confirmation email" do
#         email = open_last_email_for attrs[:email]
#         email.should be
#         email.from.should include 'no-reply@greenplantswap.co.uk'
#         email.subject.should == 'Please confirm your email address'
#         email.should have_body_text(%r{href="https://test.greenplantswap.co.uk/users})
#       end
#
#       it 'sets created_source and created_browser_user_agent' do
#         u = User.first
#         expect(u.created_source).to eq 'main'
#
#         # "Rails Testing" is the HTTP_USER_AGENT used by ActionDispatch::TestRequest
#         expect(u.created_browser_user_agent).to eq 'Rails Testing'
#       end
#     end
#
#     context 'different locales' do
#       it "should set the user locale to en-GB, locale for .co.uk domain" do
#         @request.host = 'testing.greenplantswap.co.uk'
#         post :create, user: attrs, plan: plan_codes.first
#         User.first.locale.should == 'en-GB'
#       end
#
#       # it "should set the user locale to en-US, locale for .com domain" do
#       #   @request.host = 'testing.greenplantswap.com'
#       #   post :create, user: attrs, plan: plan_codes.first
#       #   User.first.locale.should == 'en-US'
#       # end
#
#       it "should set the default locale, for other domains" do
#         @request.host = 'testing.greenplantswap.de'
#         post :create, user: attrs, plan: plan_codes.first
#         User.first.locale.should == 'en-GB'
#       end
#     end
#   end
# end
