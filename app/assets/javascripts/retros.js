


function makeRetro(form) {
    var formData = {
        'authenticity_token' : form.find('[name="authenticity_token"]').val(),
        'retro' : {
            'meeting_date': form.find('[name="retro[meeting_date]"]').val()
        }
    };
    var id = form.find('[name="project_id"]').val();
    $.ajax({
        type        : 'POST',
        url         : '/projects/' + id + '/retros',
        encode      : false,
        data        : formData,
        dataType    : 'json',
        success     : function(data) {
            $("#retro-form").html("");
            $("#retro-form").slideUp(400);
            toastr["success"]("Retro " + data.retro.id + " was successfully created");
        },
        error       : function() {
            toastr["error"]("invalid retro");
        }
    });
    event.preventDefault();
}

function renderRetro(data) {
    var template = "<tr id='retro-" + data.retro.id + "'>";
    template = template + "<td>" + data.retro.id + "</td>";
    template = template + "<td><a href='/retros/" + data.retro.id + "'>" + data.date + "</a></td>";
    template = template + "<td>";
    if (data.retro.creator_id == null) {
        template = template + "Unknown";
    }
    else {
        template = template + "<a href='/users/" + data.retro.creator_id + "'>" + data.user.name + " (" + data.user.email + ")</a>";
    }
    template = template + "</td>";
    template = template + "<td>" + data.retro.status + "</td>";
    template = template + "<td><a onclick='deleteRetro(" + data.retro.id + ")'>Destroy</a></td>";
    template = template + "</tr>";
    return template;
}

function nextReview(id, display) {
    $.ajax({
        type     : 'POST',
        url      : '/retros/'+id+'/discussed',
        encode   : false,
        dataType : 'json'
    });
    event.preventDefault();
}

function nextVotedReview(id) {
    $.ajax({
        type        : 'POST',
        url         : '/retros/'+id+'/discussed_followup',
        encode      : false,
        dataType    : 'json'
    });
    event.preventDefault();
}

function deleteRetro(id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type: 'DELETE',
            url: '/retros/' + id,
            encode: false,
            dataType: 'json',
            succes: function(data) {
                toastr["success"]("Retro " + data + " was successfully destroyed");
            }
        });
        event.preventDefault();
    }
}