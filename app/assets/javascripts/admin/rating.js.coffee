
rating_options = {
  number: 5,
  path: '/assets/raty/img',
  cancel    : true,
  cancelOff : "cancel-off.png",
  cancelOn  : "cancel-on.png",
}

colRating = ->
  el = $(this)
  rating = el.text() * 1
  el.html("<div>").find("div").raty($.extend({ 
    score: rating
    readOnly: true
  }, rating_options))

rowRating = ->
  el = $(this)
  rating = el.find('.empty').length == 0 and el.text() * 1 or 0
  el.html("<div>").find("div").raty($.extend({
    score: rating
    click: (score, evt)->
      $.ajax(location.pathname + '/rate', data: {rating: score}, method: 'PUT')
  }, rating_options))

editRating = ->
  el = $(this)
  rating = el.val() * 1
  el = $("<div>", {style: 'float: left;'})
  $(this).replaceWith(el)
  el.raty($.extend({
    score: rating
    click: (score, evt)->
      $.ajax('rate', data: {rating: score}, method: 'PUT')
  }, rating_options))

jQuery ->
  $('tr.row-rating td').each(rowRating)
  $('td.col-rating').each(colRating)
  $('#application_rating').each(editRating)
