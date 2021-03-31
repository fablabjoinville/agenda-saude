class Hasher
  include Singleton

  HASH_DICTIONARY = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.freeze
  VERSION_0 = 'A'.freeze

  attr_reader :hasher

  def initialize
    @hasher = Hashids.new(Rails.configuration.x.hashids_salt, 0, HASH_DICTIONARY)
  end

  # Returns the appointment and the patient IDs
  def find_ids(id)
    appointment_id, patient_id = hasher.decode(id.gsub(/^#{VERSION_0}/, ''))

    [appointment_id, patient_id]
  end

  def for(appointment:)
    [
      VERSION_0,
      hasher.encode(
        appointment.id,
        appointment.patient.id
      )
    ].join
  end

  class << self
    delegate :find_ids, :for, to: :instance
  end
end
