$(function() {
    $(".tbody").append("content");
});


function deleteOutstanding(id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type        : 'DELETE',
            url         : '/outstandings/'+id,
            encode      : 'true',
            dataType    : 'json'
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
            dataType    : 'json'
        });
        event.preventDefault();
    }
}

function makeTask(form) {
    var formData = {
        'authenticity_token' : form.find('[name="authenticity_token"]').val(),
        'assigned_to' : form.find('[name="assigned_to[]"]').val(),
        'outstanding' : {
            'issue_id' : form.find('[name="outstanding[issue_id]"]').val(),
            'retro_id' : form.find('[name="outstanding[retro_id]"]').val(),
            'description' : form.find('[name="outstanding[description]"]').val()
        }
    };
    var method = form.find('[name="_method"]').val();
    if (method == "POST") {
        $.ajax({
            type:       'POST',
            url:        '/issues/' + formData.outstanding.issue_id + '/outstandings',
            data:       formData,
            dataType:   'json',
            encode:     false,
            success:    function(data) {
                var form = $("#task-form-"+data.task.issue_id);
                form.slideUp(350);
                form.html("");
            }
        });
        event.preventDefault();
    }
    else if (method == "PATCH") {
        var id = form.find('[name="task_id"]').val();
        $.ajax({
            type:       'PATCH',
            url:        '/outstandings/' + id,
            data:       formData,
            dataType:   'json',
            encode:     false,
            success:    function(data) {
                var form = $("#edit-task");
                form.slideUp(400);
                form.html("");
            }
        });
        event.preventDefault();
    }
}

//takes in json of a task
// returns a string that is fully rendered HTML of a task
function renderTask(taskData) {
    var template = "<tr ";
    if (taskData.task.complete == true) {
        template = template + "class='strikeout' ";
    }
    template = template + "id='task-" + taskData.task.id + "'>";
    template = template + "<td><a href='/outstandings/" + taskData.task.id + "'>" + taskData.task.description + "</a></td>";
    if (taskData.users == 1) {
        template = template + "<td><a href='/users'>all</a></td>";
    }
    else {
        template = template + "<td>";
        for (var i=0; i<taskData.user_size; i++) {
            template = template + "<a href='/users/" + i + "'>" + taskData.users[i].name + "</a><br>";
        }
        template = template + "</td>";
    }
    template = template + "<td><a href='/issues/" + taskData.task.issue_id + "'>" + taskData.issue.description + "</a></td>";
    template = template + "<td><a data-remote='true' href='/outstandings/" + taskData.task.id + "/edit'>Edit</a></td>";
    template = template + "<td><a onclick='deleteOutstanding(" + taskData.task.id + ")'>Delete</a></td></tr>";
    return template;
}

