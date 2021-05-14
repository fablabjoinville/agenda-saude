class Page < ApplicationRecord
  CACHE_TTL = 5.minutes # just to make sure our cache is regularly clean

  enum context: {
    embedded: 0,
    user_created: 1
  }

  validates :path, :title, :body, :context, presence: true
  validates :path, uniqueness: true, format: { with: /\A[A-Za-z0-9_-]+\z/ }

  scope :admin_order, -> { order(:context, :path) }

  def html
    Rails.cache.fetch("#{cache_key_with_version}/html", expires_in: CACHE_TTL) do
      Kramdown::Document.new(body).to_html.html_safe # rubocop:disable Rails/OutputSafety
    end
  end
end
