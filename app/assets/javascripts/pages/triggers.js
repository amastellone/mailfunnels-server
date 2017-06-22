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
    var trigger_confirm_delete_modal = $('#trigger_confirm_delete_modal');
    var edit_trigger_modal = $('#editTriggerModal');

    /* --- INPUT FIELDS --- */
    var trigger_name_input = $('#trigger_name_input');
    var trigger_description_input = $('#trigger_description_input');
    var edit_trigger_name_input = $('#edit_trigger_name_input');
    var edit_trigger_description_input = $('#edit_trigger_description_input');

    /* --- SELECT INPUT FIELDS --- */
    var hook_list_select = $('#hook_list_select');
    var product_select = $('#product_list_select');
    var edit_hook_list_select = $('#edit_hook_list_select');
    var edit_product_select = $('#edit_product_list_select');

    /* --- BUTTONS --- */
    var new_trigger_submit = $('#new_trigger_submit_button');
    var trigger_refresh_button = $('#trigger_refresh_button');
    var trigger_edit_button = $('#trigger_edit_button');
    var trigger_delete_button = $('#trigger_delete_button');
    var confirm_trigger_delete_button = $('#confirm_trigger_delete_button');
    var cancel_trigger_delete_button = $('#cancel_trigger_delete_button');
    var edit_trigger_submit_button = $('#edit_trigger_submit_button');


    /* --- VIEW TEXT FIELDS --- */
    var view_trigger_name = $('#view_trigger_name');
    var view_trigger_product = $('#view_trigger_product');
    var view_trigger_hits = $('#view_trigger_hits');
    var view_trigger_description = $('#view_trigger_description');
    var view_num_funnels = $('#view_num_funnels');




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
        


        $.ajax({
            type:'POST',
            url:'/ajax_load_trigger_info',
            dataType: "json",
            data: {
                app_id: app_id,
                trigger_id: trigger_id,
                authenticity_token: csrf_token

            },
            error: function(e){
                console.log(e);
            },
            success: function(response){
                view_trigger_name.html(response.name);
                view_trigger_hits.html(response.hits);
                view_trigger_product.html(response.product_id);
                view_trigger_description.html(response.description);

                trigger_refresh_button.attr('data-id', trigger_id);
                trigger_edit_button.attr('data-id', trigger_id);
                trigger_delete_button.attr('data-id', trigger_id);
                trigger_info_modal.modal('toggle');

            }

        });
    });


    /**
     * Button On Click Function
     * ------------------------
     *
     * On Click of the edit trigger info modal
     *
     */
    trigger_edit_button.on('click', function(){
        var trigger_id = $(this).attr('data-id');
        trigger_info_modal.modal('toggle');

        $.ajax({
            type: 'POST',
            url: '/ajax_load_trigger_edit_info',
            dataType: "json",
            data: {
                app_id: app_id,
                trigger_id: trigger_id,
                authenticity_token: csrf_token
            },
            error: function(e){
                console.log(e);
            },
            success: function(response){
                console.log(response);
                edit_trigger_name_input.val(response.name);
                edit_trigger_description_input.val(response.description);
                edit_hook_list_select.val(response.hook_id);
                edit_product_select.val(response.product_id);
                edit_trigger_submit_button.attr('data-id', trigger_id);
                edit_trigger_modal.modal('toggle');

            }
        })

    });

    /**
     * Button On Click Function
     * ------------------------
     *
     * On Click of the save button in the trigger edit modal
     * Saves updated trigger info
     */
    edit_trigger_submit_button.on('click', function(){
        var trigger_id = $(this).attr('data-id');

        var trigger_name = edit_trigger_name_input.val();
        var trigger_description = edit_trigger_description_input.val();
        var trigger_product = edit_product_select.val();
        var trigger_hook = edit_hook_list_select.val();

        $.ajax({
            type: 'POST',
            url: '/ajax_save_edit_trigger',
            dataType: "json",
            data:{
                id: trigger_id,
                name: trigger_name,
                description: trigger_description,
                product_id: trigger_product,
                hook_id: trigger_hook,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                edit_trigger_modal.modal('toggle');
                window.location.reload(true);
                console.log(response);
            }

        })

    });



    /**
     * Button On Click Function
     * ------------------------
     *
     * Function called when delete button on Template Info modal is clicked
     * Retrieves Funnels that the trigger is related to
     * and opens the delete confirmation modal
     */

    trigger_delete_button.on('click', function() {
        trigger_info_modal.modal('toggle');
        var trigger_id = $(this).data('id');

        confirm_trigger_delete_button.attr('data-id', trigger_id);
        //cancel_trigger_delete_button.data('id', trigger_id);
        trigger_confirm_delete_modal.modal('toggle');

        $.ajax({
            type:'POST',
            url: '/ajax_load_trigger_funnels',
            dataType: "json",
            data: {
                app_id: app_id,
                trigger_id: trigger_id,
                authenticity_token: csrf_token
            },
            error: function(e){
                console.log(e);
            },
            success: function(response){
                view_num_funnels.html("Number of funnels " + response.name + " will be removed from: " + response.num_funnels);

            }
        })
    });

    
    
    /**
     * Button On Click Function
     * ------------------------
     * Deletes trigger while in the trigger delete confirmation modal 
     */
    
    confirm_trigger_delete_button.on('click', function() {
        
        var trigger_id = $(this).data('id');
        trigger_confirm_delete_modal.modal('toggle');
        
        $.ajax({
            type: 'POST',
            url: '/ajax_delete_trigger',
            dataType: "json",
            data:{
                app_id: app_id,
                trigger_id: trigger_id,
                authenticity_token: csrf_token
            },
            error: function(e){
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);

            }

            
        })


        
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


        $.ajax({
            type:'POST',
            url: '/ajax_process_abandoned_carts',
            dataType: "json",
            data: {
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
