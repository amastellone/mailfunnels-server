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


    $('#users_table').dataTable({
        "columnDefs": [ {
            "targets": 'no-sort',
            "orderable": false,
        } ]
    });



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