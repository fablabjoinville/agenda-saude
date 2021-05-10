module Admin
  class PagesController < Base
    before_action :set_page, only: %i[show edit update destroy]

    def index
      @pages = Page.admin_order
                     .page(index_params[:page])
                     .per(100)
    end

    def new
      @page = Page.new default_params
    end

    def create
      @page = Page.new(page_params.merge(default_params))

      if @page.save
        redirect_to admin_page_path(@page)
      else
        render :new
      end
    end

    def show; end

    def edit; end

    def update
      if @page.update(page_params)
        redirect_to admin_page_path(@page)
      else
        render :edit
      end
    end

    def destroy
      @page.destroy! if @page.user_created?
      redirect_to admin_pages_path
    end

    private

    def index_params
      params.permit(:page)
    end

    def page_params
      return params.require(:page).permit(:body) if @page&.embedded?

      params.require(:page).permit(:path, :title, :body)
    end

    def default_params
      { context: :user_created }
    end

    def set_page
      @page = Page.find(params[:id])
    end
  end
end
