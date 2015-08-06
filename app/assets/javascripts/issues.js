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


function deleteIssue(id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type        : 'DELETE',
            url         : '/issues/'+id,
            encode      : 'true',
            dataType    : 'json',
            success     : function(data) {
                var element = $("#issue-"+data["index"]+"-"+data["type"]);
                element.remove();
            }
        });
        event.preventDefault();
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
        'authenticity_token' : form.find('[name="authenticity_token"]').val(),
        'issue' : {
            'retro_id': form.find('[name="issue[retro_id]"]').val(),
            'issue_type': form.find('[name="issue[issue_type]"]').val(),
            'description': form.find('[name="issue[description]"]').val()
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
            var count = $('#votecount-'+data);
            var firstcount = count.text();
            var votecount = parseInt(firstcount);
            votecount++;
            votecount = votecount.toString();
            count.text(votecount);
            var votecount_primary = $('#votecount-primary');
            votecount = parseInt(votecount_primary.text())+1;
            votecount = votecount.toString();
            votecount_primary.text(votecount);
        }
    });
    event.preventDefault();
}


function makeIssue(form) {
    var formData = {
        'authenticity_token' : form.find('[name="authenticity_token"]').val(),
        'issue' : {
            'retro_id': form.find('[name="issue[retro_id]"]').val(),
            'issue_type': form.find('[name="issue[issue_type]"]').val(),
            'description': form.find('[name="issue[description]"]').val()
        }
    };
    var method = form.find('[name="_method"]').val();
    if (method == "POST") {
        $.ajax({
            type: 'POST', // define the type of HTTP verb we want to use (POST for our form)
            url: '/retros/' + formData.issue.retro_id + '/issues', // the url where we want to POST
            data: formData, // our data object
            dataType: 'json', // what type of data do we expect back from the server
            encode: false,
            success: function (data) {
                var form = $("#add-issue-" + data.issue.issue_type);
                form.slideUp(400);
                form.html("");


                var template = renderIssue(data);
                var issuelist = $("#" + data.issue.issue_type + "_issues");
                issuelist.append($(template));
                issuelist.append($("#" + data.issue.issue_type + "_adder"));
            }
        });
        event.preventDefault();
    }
    else if (method == "PATCH") {
        var id = form.find('[name="issue_id"]').val();
        $.ajax({
            type: 'PATCH', // define the type of HTTP verb we want to use (POST for our form)
            url: '/issues/' + id, // the url where we want to POST
            data: formData, // our data object
            dataType: 'json', // what type of data do we expect back from the server
            encode: false,
            success: function (data) {
                var form = $("edit-" + data.issue.id);
                form.slideUp(400);
                var template = renderIssue(data);
                $("#issue-" + data.index + "-" + data.issue_type).replaceWith(template);
            }
        });
        event.preventDefault();
    }
}

// takes in json of an issue
// returns a string that is fully rendered HTML of an issue
function renderIssue(issueData) {
    var votecount = "";
    var votebutton = "";
    if (issueData.retro.status == "complete") {
        votecount = "<div align='right'>votes: " + issueData.issue.votes_count + "</div>";
        if (issueData.retro.status == "voted_review") {
            votecount = votecount + "<a data-remote='true' href='/issues/" + issueData.issue.id + "/outstandings/new'>New Task</a>";
        }
    }
    if (issueData.retro.status == "voting") {
        votebutton = "<form>" +
            "<button id='submit' class='btn btn-default' onclick='addVote(" + issueData.issue.id + ")>" +
                "<span id='votecount-" + issueData.issue.id + "'>" + issueData.issue.votes_count + "</span>" +
                "</button>" +
                "</form>";
    }
    var template = "<li id='issue-" + issueData.index + "-" + issueData.issue_type + "' class='data retro-"+issueData.issue.issue_type + "'>" +
        "<a href='/users/" + issueData.issue.creator_id + "'>"+issueData.creator_name + "</a>" +
        "<span id='description'> " + issueData.issue.description + "</span>" +
        "<a onclick='deleteIssue(" + issueData.issue.id + ")' style='float: right;' >" +
        "<span class='glyphicon glyphicon-trash'></span>" +
        "</a>" +
        "<a href='/issues/"+ issueData.issue.id + "/edit' style='float: right;' data-remote='true'><span class='glyphicon glyphicon-pencil'></span></a>" +
        votecount +
        votebutton +
        "<div id='edit-" + issueData.issue.id + "' style='display:none;'></div>" +
        "</li>";
    return template;
}
