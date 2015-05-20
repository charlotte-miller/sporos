# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string(60)
#  last_name                  :string(60)
#  public_id                  :string(20)
#  email                      :string(80)       default(""), not null
#  encrypted_password         :string           default("")
#  admin                      :boolean          default("false")
#  password_salt              :string
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default("0")
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string
#  last_sign_in_ip            :string
#  confirmation_token         :string
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string
#  failed_attempts            :integer          default("0")
#  locked_at                  :datetime
#  unlock_token               :string
#  profile_image_file_name    :string
#  profile_image_content_type :string
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  profile_image_fingerprint  :string
#  profile_image_processing   :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  invitation_token           :string
#  invitation_created_at      :datetime
#  invitation_sent_at         :datetime
#  invitation_accepted_at     :datetime
#  invitation_limit           :integer
#  invited_by_id              :integer
#  invited_by_type            :string
#  invitations_count          :integer          default("0")
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invitations_count     (invitations_count)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_public_id             (public_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

class User < ActiveRecord::Base
  include AttachableFile
  include Uuidable
  # include DeviseInvitable::Inviter
  
  # ---------------------------------------------------------------------------------
  # Authentication
  # ---------------------------------------------------------------------------------
  devise  :database_authenticatable, :trackable, :validatable, :timeoutable,
          :registerable, :recoverable, :confirmable, :rememberable, :invitable  #configuration in devise.rb
          # :omniauthable, :omniauth_providers => []
         
          #https://github.com/plataformatec/devise/wiki/How-To:-Add-timeout_in-value-dynamically
          def timeout_in
            if self.admin?
              3.days
            else
              30.days
            end
          end
          
          # https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users#allowing-unconfirmed-access
          # def confirmation_required?
          #   if highest_involvement_level = self.involvements.order('level DESC').first
          #     highest_involvement_level[:level] > 0
          #   end
          # end
         
        

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_protected :id, :encrypted_password, :password_salt, :reset_password_token, :reset_password_sent_at, 
                 :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, 
                 :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, 
                 :failed_attempts, :locked_at, :encrypted_password
  
  has_public_id :public_id, prefix:'MEM', length:20
  
  has_attachable_file :profile_image,
                      :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"],
                      :processors => [:thumbnail, :paperclip_optimizer],
                      paperclip_optimizer: { jhead:true, jpegrecompress:true, jpegtran:true },
                      :styles => {
                        large:       { geometry: "1500x1500>", format: 'jpg', convert_options: "-strip" },
                        medium:      { geometry: "300x300>",   format: 'jpg', convert_options: "-strip" },
                        small:       { geometry: "200x200>",   format: 'jpg', convert_options: "-strip" },
                        large_thumb: { geometry: "120x120#",   format: 'jpg', convert_options: "-strip" },
                        thumb:       { geometry: "64x64#",     format: 'jpg', convert_options: "-strip" }
                      }

  process_in_background :profile_image
    
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_many :block_requests,                                     inverse_of: :requester
  has_many :groups,            :through => :group_memberships
  has_many :group_memberships, :dependent => :destroy,          inverse_of: :member do
    
    # association wrapped in #membership_in(group)
    def for_group(group)
      group_id = group.is_a?( Group ) ? group.id : group
      where(group_id:group_id).first
    end
  end
  
  has_many :involvements, class_name: "Involvement", dependent: :destroy, inverse_of: :user do
    def in(ministry)
      where(['ministry_id = ?', ministry.id]).first
    end
  end
  
  has_many :ministries, through: :involvements
  has_many :approval_requests
  has_many :posts do
    def pending
      where('published_at IS NULL AND rejected_at IS NULL')
    end
    
    def rejected
      where('rejected_at IS NOT NULL')
    end
  end
  
  has_many :invitations, :class_name => 'User', :foreign_key => :invited_by_id
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :email, :first_name, :last_name
  validates_length_of   :email, :maximum => 80
  validates_format_of   :email, :with => /.+@.+\..+/, :message => "looks wrong" #anything@anything.anything
  validates_length_of   :first_name, :last_name, :maximum => 60
  validates_attachment  :profile_image, :size => { :in => 0..10.megabytes }
    #, :presence => true,
    # :content_type => { :content_type => "image/jpg" }
    
    
  # ---------------------------------------------------------------------------------
  # Callbacks
  # ---------------------------------------------------------------------------------
  attr_accessor :involvement_ministry_id, :involvement_level

  after_create :create_first_involvement
  def create_first_involvement
    if involvement_ministry_id
      self.involvements.create(ministry_id:involvement_ministry_id, level_id:(involvement_level || 0))
    end
  end
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # returns a GroupMembership
  def membership_in(group)
    group_memberships.for_group(group)
  end
end
