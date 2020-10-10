require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:patient) { create(:patient, main_ubs: create(:ubs)) }

  describe 'GET #unblock' do
    context 'when patient exists' do
      it 'unblocks the patient' do
        get :unblock, params: { cpf: patient.cpf }

        expect(response.body).to eq("<h1>#{patient.name} desbloqueado!</h1>")
      end
    end

    context 'when patient does not exists' do
      it 'renders patient not found message' do
        get :unblock, params: { cpf: 'asad' }

        expect(response.body).to eq('<h1>Paciente não encontrado</h1>')
      end
    end
  end
end
