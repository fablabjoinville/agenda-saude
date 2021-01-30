function checkForComorbidities() {
  // hardcoded stuff :-(we need a better way to get the comorbidity group checkbox state)
  var comorbidityGroup = document.getElementById('patient_groups_4');
  var comorbiditiesList = document.getElementById('comorbidities-list');

  if(comorbidityGroup.checked) {
    comorbiditiesList.hidden = false;
  } else {
    comorbiditiesList.hidden = true;
  }
};
