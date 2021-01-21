class CheckInController < UserSessionController
  def search
    @ubs = Ubs.find(params[:ubs_id])
    @patient = nil

    render 'ubs/check_in/index', locals: { patient: @patient }
  end

  def find_patient
    @ubs = Ubs.find(params[:ubs_id])
    @patient = nil

    if params[:patient][:cpf].present?
      @patient = Patient.find_by(cpf: params[:patient][:cpf])
    elsif params[:patient][:name].present?
      @patient = Patient.where(name: params[:patient][:name])
    end

    render 'ubs/check_in/index', locals: { patient: @patient }
  end
end
