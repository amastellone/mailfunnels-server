
$(function() {

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_broadcast_modal = $('#new_broadcast_modal');

    /* --- TABLES --- */
    var broadcasts_table = $('#broadcasts_table');

    /* --- INPUT FIELDS --- */
    var new_broadcast_name = $('#broadcast_name_input');
    var new_broadcast_description = $('#broadcast_description_input');
    var new_broadcast_list = $('#broadcast_list_select');
    var new_broadcast_template = $('#broadcast_template_select');

    /* --- BUTTONS --- */
    var submit_new_broadcast = $('#new_broadcast_submit_button');


    //Initialize the Broadcasts Page
    init();


    submit_new_broadcast.on('click', function() {

        $.ajax({
            type: 'POST',
            url: '/ajax_new_broadcast',
            data: {
                app_id: app_id,
                name: new_broadcast_name.val(),
                description: new_broadcast_description.val(),
                email_list_id: new_broadcast_list.val(),
                email_template_id: new_broadcast_template.val(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload();
            },
            success: function(response) {
                console.log(response);
                if (response.success === true){
                    window.location.assign('/broadcast_info/' + response.broadcast_id)
                }
            }
        });

    });

    $('#broadcasts_table_length').on('change', function() {

        $('.left_col').height($('.right_col').height() + 50);
    });




    function init() {

        //Set Triggers Table to Datatable instance
        broadcasts_table.dataTable({
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false,
            } ]
        });

        $('.left_col').height($('.right_col').height() + 50);

        // Progressbar
        if ($(".progress .progress-bar")[0]) {
            $('.progress .progress-bar').progressbar();
        }
    }


});
