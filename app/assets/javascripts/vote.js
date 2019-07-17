$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    var xhr = e.detail[0];
    var resourceName = xhr['resource'];
    var resourceId = xhr['resourceId'];
    var rating = xhr['rating'];
    
    if ($(this).find('.delete').hasClass('hidden')) {
      $(this).find('.rating').html(rating);
      $(this).find('.up').hide;
      $(this).find('.up').addClass('hidden');
      $(this).find('.down').hide;
      $(this).find('.down').addClass('hidden');
      $(this).find('.delete').show;
      $(this).find('.delete').removeClass('hidden');
    }  else {
      $(this).find('.rating').html(rating);
      $(this).find('.up').show;
      $(this).find('.up').removeClass('hidden');
      $(this).find('.down').show;
      $(this).find('.down').removeClass('hidden');
      $(this).find('.delete').hide;
      $(this).find('.delete').addClass('hidden');
    }

  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('#flash').append('<p class="alert">' + value[0].message +'</p>');
      })

    })
});
