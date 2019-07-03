$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    var xhr = e.detail[0];
    var resourceName = xhr['resource'];
    var resourceId = xhr['resourceId'];
    var rating = xhr['rating'];

    
    if ($('.' + resourceName + '-' + resourceId + ' .vote .delete').hasClass('hidden')) {

      $('.' + resourceName + '-' + resourceId + ' .vote .rating').html(rating);
      $('.' + resourceName + '-' + resourceId + ' .vote .up').hide;
      $('.' + resourceName + '-' + resourceId + ' .vote .up').addClass('hidden');
      $('.' + resourceName + '-' + resourceId + ' .vote .down').hide;
      $('.' + resourceName + '-' + resourceId + ' .vote .down').addClass('hidden');
      $('.' + resourceName + '-' + resourceId + ' .vote .delete').show;
      $('.' + resourceName + '-' + resourceId + ' .vote .delete').removeClass('hidden');
    }  else {
      $('.' + resourceName + '-' + resourceId + ' .vote .rating').html(rating);
      $('.' + resourceName + '-' + resourceId + ' .vote .up').show;
      $('.' + resourceName + '-' + resourceId + ' .vote .up').removeClass('hidden');
      $('.' + resourceName + '-' + resourceId + ' .vote .down').show;
      $('.' + resourceName + '-' + resourceId + ' .vote .down').removeClass('hidden');
      $('.' + resourceName + '-' + resourceId + ' .vote .delete').hide;
      $('.' + resourceName + '-' + resourceId + ' .vote .delete').addClass('hidden');
    }

  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })

    })
});
