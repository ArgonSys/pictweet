require 'rails_helper'

RSpec.describe Tweet, type: :model do
  before do
    @tweet = FactoryBot.create(:tweet)
  end

  describe "ツイート投稿機能" do
    it "画像とテキストを投稿できる" do
      expect(@tweet).to be_valid
    end
    it "テキストが空では投稿できない" do
      @tweet.text = ''
      @tweet.valid?
      expect(@tweet.errors.full_messages).to include("テキストを入力してください")
    end
    it "画像が空では投稿できない" do
      @tweet.image = ''
      @tweet.valid?
      expect(@tweet.errors.full_messages).to include("画像を入力してください")
    end
    it "ユーザーが紐づいていなければ投稿できない" do
      @tweet.user_id = ''
      @tweet.valid?
      expect(@tweet.errors.full_messages).to include("Userを入力してください")
    end
  end
end
