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
$(document).on('click', '#favorite', function(e) {
  e.preventDefault();
  var target = $(this);
  var slug = target.data('slug');
  var url = '/villains/' + slug + '/favorite';
  $.ajax(url, {
    method: 'POST',
    success: function(data) {
      target.toggleClass('active');
      target.children('span.count').html(data);
    },
    error: function(jqXHR) {
      debugger;
    }
  });
});
$(document).on('turbolinks:load', function () {
  $('#villain_collaborator_ids').select2({
    theme: "bootstrap"
  });
  $('#villain_tag_list').select2({
    theme: "bootstrap",
    tags: true
  });
  $('#villain_organization_ids').select2({
    theme: "bootstrap"
  });
});
