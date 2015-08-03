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
            clearInterval(interval_id);
        }
    }, 1000);
    display.setAttribute("name", interval_id);
}

function nextReview(id, display) {
    $.ajax({
        type     : 'POST',
        url      : '/retros/'+id+'/discussed',
        encode   : false,
        dataType : 'json',
        success  : function(data) {
            var index = data["index"]+2;
            var previous = $("#discussed").contents();
            previous.unwrap();
            var current = $("#"+data["type"]+"_issues li:nth-child("+index+")").find("#description");
            current.wrap("<b id='discussed'></b>");
            var last_id = display.getAttribute("name");
            clearInterval(last_id);
            display.textContent = "00:30 seconds remaining, ";
            startTimer(30, display);
        }
    });
    event.preventDefault();
}

function nextVotedReview(id) {
    $.ajax({
        type        : 'POST',
        url         : '/retros/'+id+'/discussed_followup',
        encode      : 'false',
        dataType    : 'json',
        success     : function(data) {
            var index = data["index"]+2;
            var previous = $("#discussed").contents();
            previous.unwrap();
            var current =$("#"+data["type"]+"_issues li:nth-child("+index+")").find("#description");
            current.wrap("<b id='discussed'></b>");
        }
    });
    event.preventDefault();
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

function deleteOutstanding(id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type        : 'DELETE',
            url         : '/outstandings/'+id,
            encode      : 'false',
            dataType    : 'json',
            success     : function(data) {
                var element = $("#task-"+data);
                element.remove();
            }
        });
        event.preventDefault();
    }
}

function markAsDone(id, task_id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type        : 'POST',
            url         : '/retros/'+id+'/outstandings/'+task_id+'/complete',
            encode      : 'false',
            dataType    : 'json',
            success     : function(data) {
                var element = $("#task-"+data);
                element.addClass("strikeout");
            }
        });
        event.preventDefault();
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

function addVote(id) {
    $.ajax({
        type        : 'POST',
        url         : '/issues/'+id+'/votes',
        dataType    : 'json',
        encode      : false,
        success     : function(data) {
            var firstcount = $('#votecount-'+data).text();
            var votecount = parseInt(firstcount);
            votecount++;
            votecount = votecount.toString();
            $('#votecount-'+data).text(votecount);
            votecount = parseInt($('#votecount-primary').text())+1;
            votecount = votecount.toString();
            $('#votecount-primary').text(votecount);
        }
    });
    event.preventDefault();
}