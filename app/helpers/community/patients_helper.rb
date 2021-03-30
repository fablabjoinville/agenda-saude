module Community
  module PatientsHelper
    def optional_field_tag
      tag.span(class: 'badge badge-light') do
        'opcional'
      end
    end
  end
end
