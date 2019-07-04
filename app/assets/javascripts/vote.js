$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    var xhr = e.detail[0];
    var resourceName = xhr['resource'];
    var resourceId = xhr['resourceId'];
    var rating = xhr['rating'];
    var vote = '.' + resourceName + '-' + resourceId + ' .vote'

    if ($(vote + ' .delete').hasClass('hidden')) {
      $(vote + ' .rating').html(rating);
      $(vote + ' .up').hide;
      $(vote + ' .up').addClass('hidden');
      $(vote + ' .down').hide;
      $(vote + ' .down').addClass('hidden');
      $(vote + ' .delete').show;
      $(vote + ' .delete').removeClass('hidden');
    }  else {
      $(vote + ' .rating').html(rating);
      $(vote + ' .up').show;
      $(vote + ' .up').removeClass('hidden');
      $(vote + ' .down').show;
      $(vote + ' .down').removeClass('hidden');
      $(vote + ' .delete').hide;
      $(vote + ' .delete').addClass('hidden');
    }

  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('#flash').append('<p class="alert">' + value[0].message +'</p>');
      })

    })
});
