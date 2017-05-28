/**
 * Created by lukehelminiak on 5/17/17.
 */
$(function(){

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    $('#triggers_table').dataTable({
        "columnDefs": [ {
            "targets": 'no-sort',
            "orderable": false,
        } ]
    });


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_trigger_modal = $('#newTriggerModal');

    /* --- INPUT FIELDS --- */
    var trigger_name_input = $('#trigger_name_input');
    var trigger_description_input = $('#trigger_description_input');
    var hook_list_select = $('#hook_list_select');

    /* --- BUTTONS --- */
    var new_trigger_submit = $('#new_trigger_submit_button');


    /**
     * Button On Click Function
     * ------------------------
     *
     * Function called when new funnel form is submitted
     * Retrieves input from fields and makes API call to
     * create a new trigger instance
     *
     */
    new_trigger_submit.on('click', function(e) {

        e.preventDefault();

        var trigger_name = trigger_name_input.val();
        var trigger_description = trigger_description_input.val();
        var hook_id = hook_list_select.val();



        $.ajax({
            type:'POST',
            url: '/create_trigger',
            dataType: "json",
            data: {
                app_id: app_id,
                hook_id: hook_id,
                name: trigger_name,
                description: trigger_description,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_trigger_modal.modal('toggle');
            }
        });

    });


});
