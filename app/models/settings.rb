class Settings
  def self.[](name)
    instance[name]
  end

  def self.instance
    if Rails.env.production?
      @instance ||= Rails.application.config_for(:application)
    else
      Rails.application.config_for(:application)
    end
  end
end
