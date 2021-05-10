class Page < ApplicationRecord
  enum context: {
    embedded: 0,
    user_created: 1
  }

  validates :path, :title, :body, :context, presence: true
  validates :path, uniqueness: true

  scope :admin_order, -> { order(:context, :path) }

  def html
    Kramdown::Document.new(body).to_html.html_safe # rubocop:disable Rails/OutputSafety
  end
end
