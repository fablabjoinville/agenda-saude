class PhoneFormatValidator < ActiveModel::EachValidator #stardard lib rails
  def validate_each(record, attribute, value)
    return if Phonelib.valid?(value)

    record.errors.add(attribute, :invalid)
  end
end
