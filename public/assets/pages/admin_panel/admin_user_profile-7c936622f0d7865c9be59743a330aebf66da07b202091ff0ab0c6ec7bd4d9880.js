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
    user_id = $('#current_user_id').val();


    /* --- COMPONENTS --- */
    var delete_app_modal = $('#mf_confirm_delete_app');
    var delete_app_submit = $('#mf_delete_app_submit');



    $('.mf_delete_app_btn').on('click', function() {

        delete_app_submit.attr('data-id', $(this).data('id'));

        delete_app_modal.modal('toggle');

    });

    delete_app_submit.on('click', function() {

        $.ajax({
            type:'POST',
            url: '/admin_delete_app',
            data: {
                app_id: $(this).attr('data-id'),
                authenticity_token: csrf_token
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


    $('.mf_enable_app_btn').on('click', function() {
        $.ajax({
            type:'POST',
            url: '/ajax_enable_app',
            dataType: "json",
            data: {
                app_id: $(this).data('id'),
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
    });


    $('.mf_disable_app_btn').on('click', function() {
        $.ajax({
            type:'POST',
            url: '/ajax_disable_app',
            dataType: "json",
            data: {
                app_id: $(this).data('id'),
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
    });

    //Initialize the Admin Panel Page
    init();



    function init() {


    }



});
