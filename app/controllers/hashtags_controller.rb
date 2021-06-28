class HashtagsController < ApplicationController
  def show
    hashtag = Hashtag.with_questions.find_by!(text: params[:text])
    @questions = hashtag.questions
    @hashtags = Hashtag.all
  end
end
