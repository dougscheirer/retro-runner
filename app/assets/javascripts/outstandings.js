
function deleteOutstanding(id) {
    if (confirm("Are you sure?") == true) {
        $.ajax({
            type        : 'DELETE',
            url         : '/outstandings/'+id,
            encode      : 'false',
            dataType    : 'json',
            success     : function(id) {
                var element = $("#task"+id);
                element.remove();
            }
        });
        event.preventDefault();
    }
}