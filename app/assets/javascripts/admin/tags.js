+ function ($) {

 var initialize = function () {
   $('[name*=tag_list]').each(function () {
     $(this).select2({
       tags: $(this).data('tags') || [],
       allowCreate: true,
       tokenSeparators: [',']
     })
   })
 }

  $(initialize) 

}(jQuery)