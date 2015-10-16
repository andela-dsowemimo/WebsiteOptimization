class AuthorController < ApplicationController
  def index
    @authors = (Author.all.select(:id, :name, :updated_at)).page(params[:page]).per(30)
  end
end
