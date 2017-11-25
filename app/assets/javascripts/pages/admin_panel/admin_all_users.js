/**
 * jQuery Handler for the Admin Panel
 */


/* --- GLOABL VARIABLES DECLARATION --- */
var csrf_token;
var app_id;


$(function() {

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    app_id = $('#current_app_id').val();


    /* --- MODALS --- */
    var user_info_modal = $('#user_info_modal');
    var new_user_modal = $('#new_mf_user_modal');

    /* --- BUTTONS --- */
    var new_user_button = $('#mf_admin_add_user');
    var new_user_submit_button = $('#mf_new_user_submit');

    /* --- COMPONENTS --- */
    var current_user_id = $('#modal_user_id');
    var user_inf_id = $('#view_user_inf_id');
    var user_first_name = $('#view_user_first_name');
    var user_last_name = $('#view_user_last_name');
    var user_email = $('#view_user_email');

    var new_user_inf_id = $('#mf_new_user_inf_id');
    var new_user_email = $('#mf_new_user_email');

    //Initialize the Admin Panel Page
    init();


    $('.mf_admin_user_info').on('click', function() {

        // Get the user ID from row
        var user_id = $(this).data('id');

        current_user_id.val(user_id);

        // Retrieve User info
        $.ajax({
            type: 'POST',
            url: '/mf_api_get_user_info',
            data: {
                user_id: user_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    user_inf_id.html(response.user_infusionsoft_id);
                    user_first_name.html(response.user_first_name);
                    user_last_name.html(response.user_last_name);
                    user_email.html(response.user_email);
                    user_info_modal.modal('toggle');
                }
            }

        });

    });

    new_user_button.on('click', function() {
        new_user_modal.modal('toggle');
    });

    new_user_inf_id.on('change', function() {
        validateNewUserInput();
    });

    new_user_email.on('keyup', function() {
        validateNewUserInput();
    });


    new_user_submit_button.on('click', function() {

        if (new_user_inf_id.val() === '' || new_user_email.val() === '') {
            new_user_submit_button.prop('disabled', true);
            return;
        }

        $.ajax({
            type: 'POST',
            url: '/mf_api_manually_add_user',
            data: {
                client_id: new_user_inf_id.val(),
                email: new_user_email.val()
            },
            error: function(e) {
                console.log(e);
                window.location.reload();
            },
            success: function(response) {
                console.log(response);
                window.location.reload();
            }

        });



    });



    function init() {

        $('#users_table').dataTable({
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false,
            } ]
        });

        //Disable New User Submit Button
        new_user_submit_button.prop('disabled', true);

    }


    function validateNewUserInput() {

        if (new_user_inf_id.val() === '' || new_user_email.val() === '') {
            new_user_submit_button.prop('disabled', true);
        } else {
            new_user_submit_button.prop('disabled', false);
        }
    }




});


/**
 * Function that will enable the app with the ID passed to it
 *
 * @param id
 */
function enableApp(id) {

    $.ajax({
        type:'POST',
        url: '/ajax_enable_app',
        dataType: "json",
        data: {
            app_id: id,
            authenticity_token: csrf_token
        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            console.log(response);
            window.location.reload(true);
        }
    });

}


/**
 * Function that will disable the app with the ID passed to it
 *
 * @param id
 */
function disableApp(id) {

    $.ajax({
        type:'POST',
        url: '/ajax_disable_app',
        dataType: "json",
        data: {
            app_id: id,
            authenticity_token: csrf_token
        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            console.log(response);
            window.location.reload(true);
        }
    });

}