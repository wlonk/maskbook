$(document).on('keydown', 'textarea', function(e) {
  if(e.keyCode == 13 && (e.metaKey || e.ctrlKey)) {
    $(this).parents('form').submit()
  }
});

$(document).on('click', '#get_feed', function(e) {
  e.preventDefault();
  var form = $('#filterrific_filter').serialize();
  var qs = $.query.parseNew(form)
    .set("s[sorted_by]", "created_at_desc")
    .set('format', 'atom')
    .toString();
  window.location.search = qs;
});
