/**
 * Created by lukehelminiak on 5/17/17.
 */


/* --- GLOABL VARIABLES DECLARATION --- */
var csrf_token;
var app_id;


$(function(){

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');


    /* --- APP VALUES --- */
    app_id = $('#current_app_id').val();

    /* --- TABLES --- */
    var triggers_table = $('#triggers_table');

    /* --- MODALS --- */
    var new_trigger_modal = $('#newTriggerModal');
    var trigger_info_modal = $('#trigger_info_modal');

    /* --- INPUT FIELDS --- */
    var trigger_name_input = $('#trigger_name_input');
    var trigger_description_input = $('#trigger_description_input');

    /* --- SELECT INPUT FIELDS --- */
    var hook_list_select = $('#hook_list_select');
    var product_select = $('#product_list_select');

    /* --- BUTTONS --- */
    var new_trigger_submit = $('#new_trigger_submit_button');
    var trigger_refresh_button = $('#trigger_refresh_button');



    //Initialize the Triggers Page
    init();


    /**
     * Button On Click Function
     * ------------------------
     *
     * On Click of the view trigger info modal
     *
     */
    $('.view_trigger_info_button').on('click', function() {

        //Get Current Trigger ID
        var trigger_id = $(this).data('id');

        trigger_refresh_button.data('id', trigger_id);
        trigger_info_modal.modal('toggle');

    });


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
        var product_id = product_select.val();



        $.ajax({
            type:'POST',
            url: '/create_trigger',
            dataType: "json",
            data: {
                app_id: app_id,
                hook_id: hook_id,
                name: trigger_name,
                product_id: product_id,
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


    /**
     * On Trigger Refresh Button Click
     *
     * Refreshes the trigger to check for new hits
     */
    trigger_refresh_button.on('click', function() {

        var trigger_id = $(this).data('id');

        $.ajax({
            type:'POST',
            url: '/ajax_process_abandoned_carts',
            dataType: "json",
            data: {
                trigger_id: trigger_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload(true);

            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
            }
        });


    });


    //Initialize the Triggers Page
    function init() {

        //Set Triggers Table to Datatable instance
        triggers_table.dataTable({
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false,
            } ]
        });

    }


});
