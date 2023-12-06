require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end
  describe "ユーザー新規登録" do
    it 'nicknameとemail、passwordとpassword_confirmationが存在すれば登録できる' do
      expect(@user).to be_valid
    end
    it 'nicknameが空では登録できない' do
      @user.nickname = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("ニックネームを入力してください")
    end
    it 'emailが空では登録できない' do
      @user.email = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("Eメールを入力してください")
    end
    it 'passwordが空では登録できない' do
      @user.password = ''
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードを入力してください")
    end
    it 'passwordとpassword_confirmationが不一致では登録できない' do
      @user.password_confirmation += 'a'
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワード（確認用）とパスワードの入力が一致しません")
    end
    it 'nicknameが7文字以上では登録できない' do
      @user.nickname = Faker::Name.initials(number: 7)
      @user.valid?
      expect(@user.errors.full_messages).to include("ニックネームは6文字以内で入力してください")
    end
    it '重複したemailが存在する場合は登録できない' do
      @user.save
      email = @user.email
      @user = FactoryBot.build(:user)
      @user.email = email
      @user.valid?
      expect(@user.errors.full_messages).to include("Eメールはすでに存在します")
    end
    it 'emailは@を含まないと登録できない' do
      @user.email = @user.email.delete('@')
      @user.valid?
      expect(@user.errors.full_messages).to include("Eメールは不正な値です")
    end
    it 'passwordが5文字以下では登録できない' do
      @user.password = Faker::Name.initials(number: 5)
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードは6文字以上で入力してください")
    end
    it 'passwordが129文字以上では登録できない' do
      @user.password = Faker::Name.initials(number: 130)
      @user.valid?
      expect(@user.errors.full_messages).to include("パスワードは128文字以内で入力してください")
    end
  end
end
