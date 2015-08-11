
function nextReview(id, display) {
    $.ajax({
        type     : 'POST',
        url      : '/retros/'+id+'/discussed',
        encode   : false,
        dataType : 'json',
        success  : function(data) {
            var index = data.index+2;
            var previous = $("#discussed").contents();
            previous.unwrap();
            var current = $("#"+data.type+"_issues li:nth-child("+index+")").find("#description");
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
            /*var index = data["index"]+2;
            var previous = $("#discussed").contents();
            previous.unwrap();
            var current =$("#"+data["type"]+"_issues li:nth-child("+index+")").find("#description");
            current.wrap("<b id='discussed'></b>");*/
        }
    });
    event.preventDefault();
}