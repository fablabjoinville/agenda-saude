function updateSubGroups(group_id) {
  var parentCheckbox = document.getElementById(`patient_groups_${group_id}`);
  var subGroupsList = document.getElementById(`subgroups-list-${group_id}`);

  if(subGroupsList == undefined) {
    return;
  }

  if(parentCheckbox.checked) {
    subGroupsList.hidden = false;
  } else {
    subGroupsList.hidden = true;
  }
};

function initializeSpecificComorbidityOnChange() {
  var specificComorbidity = document.getElementsByClassName("specificComorbidity")[0];

  specificComorbidity.setAttribute("onchange", "toggleSpecificComorbidity()");
}

function toggleSpecificComorbidity() {
  var specificComorbidity = document.getElementsByClassName("specificComorbidity")[0];
  var specificComorbidityInput = document.getElementById("specific-comorbidity-input");

  if(specificComorbidity.checked) {
    specificComorbidityInput.hidden = false;
  } else {
    specificComorbidityInput.hidden = true;
  }
}
