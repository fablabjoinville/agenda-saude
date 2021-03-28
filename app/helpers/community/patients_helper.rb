module Community::PatientsHelper
  def optional_field_tag
    content_tag :span, class: "badge badge-light" do
      "opcional"
    end
  end
end
