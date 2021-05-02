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
