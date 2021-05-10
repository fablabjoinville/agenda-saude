class PagesController < ApplicationController
  def show
    @page = Page.find_by!(context: :user_created, path: params[:id])
  end
end
