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

    /* --- COMPONENTS --- */
    var current_user_id = $('#modal_user_id');
    var user_inf_id = $('#view_user_inf_id');
    var user_first_name = $('#view_user_first_name');
    var user_last_name = $('#view_user_last_name');
    var user_email = $('#view_user_email');


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


    function init() {

        $('#users_table').dataTable({
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false,
            } ]
        });


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