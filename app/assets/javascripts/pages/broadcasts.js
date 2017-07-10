
$(function() {

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_broadcast_modal = $('#new_broadcast_modal');

    /* --- TABLES --- */
    var broadcasts_table = $('#broadcasts_table');


    //Initialize the Broadcasts Page
    init();




    function init() {

        //Set Triggers Table to Datatable instance
        broadcasts_table.dataTable({
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false,
            } ]
        });
    }


});