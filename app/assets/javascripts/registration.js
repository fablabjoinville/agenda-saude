// Enables and disables showing child checkboxes.
function groupToggle(parent) {
  let parentId = $(parent).data('group-parent')
  let child = $(`[data-group-child='${parentId}']`)

  if (child === undefined) return;

  if (parent.prop('checked')) {
    child.prop("hidden", false)
  } else {
    child.find('input').prop('checked', false)
    child.prop("hidden", true)
  }
}

// Turns 'required' on and off in order to make sure at least one in the group is checked.
function requireToggle(requiredCheckboxes) {
  console.log(`required is ${!requiredCheckboxes.is(':checked')}`)
  requiredCheckboxes.prop('required', !requiredCheckboxes.is(':checked'))
}
