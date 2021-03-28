class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value&.match(/\([1-9]{2}\) (?:9[1-9][0-9]{3}|[1-9][0-9]{3})\-[0-9]{4}/)

    record.errors.add(attribute, :invalid)
  end
end
