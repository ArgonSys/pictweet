class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show]
  before_action :no_sesstion_to_index, except: [:index, :show, :search]

  # multiple redirects error
  # create, update, destroyアクションを抜けてafter_actionメソッドを処理
  # アクション抜けたときにリダイレクトが入るらしい。
  # after_action :to_index, only: [:create, :update, :destroy]

  def index
    @tweets = Tweet.includes(:user).order("created_at  DESC")
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
  end

  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(tweet_params)
    redirect_to(action: :index)
  end

  def edit
  end

  def update
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
    redirect_to(action: :index)
  end

  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy
    redirect_to(action: :index)
  end

  def search
    @tweets = Tweet.search(params[:keyword])
  end

  private
  def tweet_params
    params.require(:tweet).permit(:text, :image).merge(user_id: current_user.id)
  end

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def no_sesstion_to_index
    redirect_to(action: :index) unless user_signed_in?
  end
end
