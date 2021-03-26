module Operator
  module AppointmentsHelper
    def operator_nav_link(text, filter)
      tag.li(class: 'nav-item') do
        link_to text, operator_appointments_path(filter: filter), class: "nav-link #{filter == @filter && :active}"
      end
    end
  end
end
