class AuthorController < ApplicationController
  def index
    @page_number = params[:page] || 1
    @authors = (Author.select(:id, :name, :updated_at).all).page(params[:page]).per(30)
  end
end
