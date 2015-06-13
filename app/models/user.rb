class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true
  validate :disallow_email_and_url_names

  private

  def disallow_email_and_url_names
    [:full_name].each do |field|
      val = send(field)

      if val.present?
        errors.add(field, :cannot_contain_email) if val =~ /@/
        errors.add(field, :cannot_contain_url) if val =~ %r{://} || val =~ /www\./
      end
    end
  end
end
