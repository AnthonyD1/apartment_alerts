window.markSeen = function (event, post_id) {
  Rails.ajax({
    url: `/craigslist_posts/${post_id}.js`,
    type: "patch",
    data: "post[seen]=true"
  })
}
