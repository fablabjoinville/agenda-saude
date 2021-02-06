class TimeSlotGenerationConfig < ActiveRecord::Base
  serialize :content

  belongs_to :ubs

  def [](key)
    return nil if !content.is_a?(Hash)
    content[key]
  end

  def []=(key, value)
    self.content ||= {}
    content[key] = value
  end
end
