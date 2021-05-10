class PagesController < ApplicationController
  def show
    @page = Page.find_by!(context: :user_created, path: params[:path])
    @html = @page.html
  end
end
