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
