class CpfFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    strict = options[:strict].present?
    size = options[:strict].present? ? 14 : 11
    return if value.try(:size) == size && CPF.valid?(value, strict: strict)

    record.errors.add(attribute, :invalid)
  end
end
