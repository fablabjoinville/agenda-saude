module Operator
  module AppointmentsHelper
    def operator_nav_link(text, filter, data: nil)
      tag.li(class: 'nav-item') do
        link_to text, operator_appointments_path(filter: filter), class: "nav-link #{filter == @filter && :active}",
                data: data
      end
    end
  end
end
