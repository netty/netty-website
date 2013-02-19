function validateGlobalSearchQuery() {
  var gsq = document.getElementById('global-search-query');
  return gsq && gsq.value.length > 0;
}

function validate404SearchQuery() {
  var gsq = document.getElementById('404-search-query');
  return gsq && gsq.value.length > 0;
}

