$(document).on('turbolinks:load', function(){
  $('.vote').on('ajax:success', function(e) {
    var xhr = e.detail[0];
    var resourceName = xhr['resource'];
    var resourceId = xhr['resourceId'];
    var rating = xhr['rating'];


    $('.' + resourceName + '-' + resourceId + ' .vote .rating').html(rating);
    $('.' + resourceName + '-' + resourceId + ' .vote .up').hide;
    $('.' + resourceName + '-' + resourceId + ' .vote .down').hide;
    $('.' + resourceName + '-' + resourceId + ' .vote .delete').remoteClass('hidden');
  })
    .on('ajax:error', function (e) {
      var errors = e.detail[0];

      $.each(errors, function(index, value) {
        $('.answer-errors').append('<p>' + value + '</p>');
      })

    })
});
