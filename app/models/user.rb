class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books

  has_many :active_relationships,  class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed # 自分がフォローしている人
  has_many :followers, through: :passive_relationships, source: :follower # 自分をフォローしている人

  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  attachment :profile_image, destroy: false

  # フォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # フォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # フォローしているか確認
  def following?(other_user)
    following.include?(other_user)
  end

  validates :name,presence: true, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: { maximum: 50 }
end
