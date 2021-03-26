class ConditionService
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def groups_ubs_available
    conditions_pluck = create_conditions_pluck(@start_time, @end_time)

    return conditions_pluck if conditions_pluck.nil?

    groups_ubs = description_groups(conditions_pluck)
    return nil if groups_ubs.blank?
    groups_ubs
  end

  def patient_in_available_group(patient)
    conditions_pluck = create_conditions_pluck(@start_time, @end_time)
    return conditions_pluck if conditions_pluck.nil?

    conditions_pluck.each do |conditions|
      group_id = conditions[0]
      min_age = conditions[1]
      comorbidity = conditions[2]
      ubs_id = conditions[3]

      ubs = Ubs.find(ubs_id)
      next unless ubs.active

      if group_id == nil && min_age > 0 && comorbidity == false
        return true if patient.age >= min_age
      elsif group_id == nil && min_age > 0 && comorbidity == true
        return true if patient.age >= min_age && patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
      elsif group_id != nil && min_age > 0 && comorbidity == false
        return true if patient.groups.include?(Group.find(group_id)) && patient.age >= min_age
      elsif group_id != nil && min_age > 0 && comorbidity == true
        return true if patient.groups.include?(Group.find(group_id)) && patient.age >= min_age && patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
      end
    end
    false
  end

  def group_ubs_appointments(patient)
    conditions_pluck = create_conditions_pluck(@start_time, @end_time)
    return conditions_pluck if conditions_pluck.nil?

    ubs_appointments_per_group = appointments_ubs(conditions_pluck, patient, @start_time, @end_time)
    return ubs_appointments_per_group
  end

  private

  def create_conditions_pluck(start_time, end_time)
    appointments_available = Appointment.where(start: start_time..end_time, patient_id: nil, active: true)

    return nil unless appointments_available.exists?

    return appointments_available.pluck(:group_id, :min_age, :commorbidity, :ubs_id).uniq
  end

  def description_groups(conditions_pluck)
    group_ubs = {}

    conditions_pluck.each do |conditions|
      group_id = conditions[0]
      min_age = conditions[1]
      comorbidity = conditions[2]
      ubs_id = conditions[3]

      ubs = Ubs.find(ubs_id)
      next unless ubs.active

      if group_id == nil && min_age > 0 && comorbidity == false
        groups_description = "População em geral com #{min_age} anos ou mais"
      elsif group_id == nil && min_age > 0 && comorbidity == true
        groups_description = "População em geral com #{min_age} anos ou mais que possua alguma comorbidade"
      elsif group_id != nil && min_age > 0 && comorbidity == false
        groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais"
      elsif group_id != nil && min_age > 0 && comorbidity == true
        groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais que possua alguma comorbidade"
      end

      if group_ubs.include?(groups_description)
        group_ubs[groups_description] << ubs.name
      else
        group_ubs[groups_description] = [ubs.name]
      end
    end
    group_ubs
  end

  def appointments_ubs(conditions_pluck, patient, start_time, end_time)
    group_ubs_appointments = {}

    conditions_pluck.each do |conditions|
      ubs_appointments_available = {}
      group_id = conditions[0]
      min_age = conditions[1]
      comorbidity = conditions[2]
      ubs_id = conditions[3]

      ubs = Ubs.find(ubs_id)
      next unless ubs.active

      if group_id == nil && min_age > 0 && comorbidity == false
        if patient.age >= min_age
          groups_description = "População em geral com #{min_age} anos ou mais"
          appointments = Appointment.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs_id, patient_id: nil, start: start_time..end_time)
        end
      elsif group_id == nil && min_age > 0 && comorbidity == true
        if patient.age >= min_age && patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
          groups_description = "População em geral com #{min_age} anos ou mais que tenha alguma comorbidade"
          appointments = Appointment.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs_id, patient_id: nil, start: start_time..end_time)
        end
      elsif group_id != nil && min_age > 0 && comorbidity == false
        if patient.age >= min_age && patient.groups.include?(Group.find(group_id))
          groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais"
          appointments = Appointment.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs_id, patient_id: nil, start: start_time..end_time)
        end
      elsif group_id != nil && min_age > 0 && comorbidity == true
        if patient.age >= min_age && patient.groups.include?(Group.find(group_id)) && patient.groups.include?(Group.find_by(name: 'Portador(a) de comorbidade'))
          groups_description = "#{Group.find(group_id).name} com #{min_age} anos ou mais que tenha alguma comorbidade"
          appointments = Appointment.where(group_id: group_id, min_age: min_age, commorbidity: comorbidity, ubs_id: ubs_id, patient_id: nil, start: start_time..end_time)
        end
      end

      next if appointments.nil?

      ubs_appointments_available[ubs_id] = appointments

      if group_ubs_appointments[groups_description].nil?
        group_ubs_appointments[groups_description] = [ubs_appointments_available]
      else
        group_ubs_appointments[groups_description] << ubs_appointments_available
      end
    end
    group_ubs_appointments
  end
end
