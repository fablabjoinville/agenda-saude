class CpfFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if CPF.valid?(value)

    record.errors.add(attribute, :invalid)
  end
end
