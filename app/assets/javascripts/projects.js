// make the click behavior once the cards are made
$(document).ready(function(){
    $('.project-card').click(function(e) {
        window.location.href($(e.target).data('retros-url'));
    })
})
