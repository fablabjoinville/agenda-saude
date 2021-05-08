class TimeOfDayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) if value.present? && Tod::TimeOfDay.try_parse(value).nil?
  end
end
