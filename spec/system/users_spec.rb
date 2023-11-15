require 'rails_helper'

RSpec.describe "UsersSignin", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end
  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      visit root_path
      expect(page).to have_content('新規登録')
      visit new_user_registration_path
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change{ User.count }.by(1)
      expect(page).to have_current_path(root_path)
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      visit root_path
      expect(page).to have_content('新規登録')
      visit new_user_registration_path
      fill_in 'Nickname', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(0)
      expect(page).to have_current_path(new_user_registration_path)
    end
  end
end


RSpec.describe "UsersLogin", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context "ユーザーがログインできるとき" do
    it "正しいユーザー情報を入力すればログインできる" do
      #トップページアクセス
      visit root_path
      #ログインボタンの確認
      expect(page).to have_content('ログイン')
      #ログインページへの遷移
      visit new_user_session_path
      #ユーザー情報の記入
      fill_in "Email", with: @user.email
      fill_in "Password", with: @user.password
      #commit
      find('input[name="commit"]').click
      #トップページへのリダイレクトを確認
      expect(page).to have_current_path(root_path)
      #カーソルを合わせるとログアウトボタンが表示される
      expect(
        find('.user_nav').find('span').hover
      ).to have_content('ログアウト')
      binding.pry
      #サインアップページへのボタンやログインページへのボタンがない
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end

  context "ユーザーがログインできないとき" do
    it "誤ったユーザー情報を入力するとログインできない" do
      #トップページアクセス
      visit root_path
      #ログインボタンの確認
      expect(page).to have_content('ログイン')
      #ログインページへの遷移
      visit new_user_session_path
      #ユーザー情報の記入
      fill_in "Email", with: (@user.email+'a')
      fill_in "Password", with: @user.password
      #commit
      find('input[name="commit"]').click
      #ログインページへのリダイレクトを確認
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end
