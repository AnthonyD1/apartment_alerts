window.markSeen = function (event, post_id) {
  Rails.ajax({
    url: `/craigslist_posts/${post_id}.js`,
    type: "patch",
    data: "post[seen]=true"
  })
}

window.toggleMassDeleteButton = function () {
  checkedBoxes = document.querySelectorAll('#posts_:checked')
  deleteSelectedButton = document.querySelector('#delete-all')

  if (checkedBoxes.length > 0) {
    deleteSelectedButton.disabled = false;
  } else {
    deleteSelectedButton.disabled = true;
  }
}
