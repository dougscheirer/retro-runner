// main JS runner

$(function() {
    $(".tbody").append("content");
});


function startTimer(duration, display) {
    var timer = duration, minutes, seconds;
    var interval_id = setInterval(function () {
        minutes = parseInt(timer / 60, 10);
        seconds = parseInt(timer % 60, 10);

        minutes = minutes < 10 ? "0" + minutes : minutes;
        seconds = seconds < 10 ? "0" + seconds : seconds;

        display.textContent = minutes + ":" + seconds + " seconds remaining, ";

        if (--timer < 0) {
            display.textContent = "";
        }
    }, 1000);
}

function deleteIssue(id, marker) {
    var request = new XMLHttpRequest();
    request.onreadystatechange = function() {
        var element = $("#"+marker);
        element.remove();
   };
    if (confirm("Are you sure?") == true) {
        request.open("DELETE", "/issues/"+id, true);
        request.send();
    }
}



function addIssue(form) {
    var formData = {
        'authenticity_token' : form.querySelector('[name="authenticity_token"]').value,
        'issue' : {
            'retro_id': form.querySelector('[name="issue[retro_id]"]').value,
            'issue_type': form.querySelector('[name="issue[issue_type]"]').value,
            'description': form.querySelector('[name="issue[description]"]').value
        }
    };
    var retro_id = form.querySelector('[name="issue[retro_id]"]').value;
    var issue_type = form.querySelector('[name="issue[issue_type]"]').value;
    $.ajax({
        type        : 'POST', // define the type of HTTP verb we want to use (POST for our form)
        url         : '/retros/'+retro_id+'/issues', // the url where we want to POST
        data        : formData, // our data object
        dataType    : 'json', // what type of data do we expect back from the server
        encode      : false,
        success     : function(data) {
            $.ajax({
                type     : 'GET',
                url      : '/issues/'+data["id"],
                dataType : 'js',
                encode   : false
            });
        }
    });
    event.preventDefault();
}