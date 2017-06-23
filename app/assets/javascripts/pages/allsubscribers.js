/* --- APP VALUES DECLARATIONS --- */
var csrf_token;
var app_id;
var email_list_id;
var subscriber_info_modal;
var clicked_view_info =0;
$(function() {


    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();
    email_list_id = $('#current_email_list_id').val();

    /* --- TABLES --- */
    var subscribers_table = $('#subscribers_table');

    /* --- MODALS --- */
    var new_subscriber_modal = $('#new_subscriber_modal');
    var new_batch_email_modal = $('#new_batch_email_modal');

    var subscriber_info_modal = $('#subscriber_info_modal');
    var import_csv_modal = $('#import_csv_modal');


    /* --- INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var template_list_select = $('#template_list_select');
    var email_list_name = $('#email_list_name');
    var subscriber_confirm_checkbox = $('#subscriber_confirm_checkbox');

    /* --- BUTTONS --- */
    var import_csv_submit_button = $('#import_csv_submit_button')
    var import_csv_button = $('#import_csv_button');
    var subscribers_export_button = $('#subscribers_export_button');
    var new_subscriber_submit_button = $('#new_subscriber_submit_button');
    var batch_email_send_button = $('#batch_email_send_button');
    var view_subscriber_info_button = $('#view_subscriber_info_button');



    //Initialize the Page
    init();

    /**
     * Import subscribers modal toggle
     */
    import_csv_button.on('click', function(){
        import_csv_modal.modal('toggle');
    });



    import_csv_submit_button.on('click', function(){
        var file = new FormData($('#file')[0]);
        $.ajax({
            // Your server script to process the upload
            url: '/ajax_import_csv',
            type: 'POST',

            // Form data
            data: {
                csv: file,
                authenticity_token: csrf_token
            },

            cache: false,
            contentType: false,
            processData: false,

            // Custom XMLHttpRequest
            xhr: function() {
                var myXhr = $.ajaxSettings.xhr();
                if (myXhr.upload) {
                    // For handling the progress of the upload
                    myXhr.upload.addEventListener('progress', function(e) {
                        if (e.lengthComputable) {
                            $('progress').attr({
                                value: e.loaded,
                                max: e.total,
                            });
                        }
                    } , false);
                }
                return myXhr;
            },
        });
    });


    /**
     * On Export Button Click
     *
     * Exports the All Subscribers Table to CSV
     */
    subscribers_export_button.on('click', function() {
        subscribers_table.tableToCSV();
    });


    /**
     * On Subscriber Checkbox Confirm change check to see
     * whether the checkbox is checked and enable the submit button
     * otherwise disable the button
     *
     */
    subscriber_confirm_checkbox.on('change', function() {

        if($(this).is(":checked") && email_input.val() !== '') {
            new_subscriber_submit_button.prop('disabled', false);
        } else {
            new_subscriber_submit_button.prop('disabled', true);
        }

    });


    email_input.on('keyup', function() {

        if ($(this).val() === '') {
            new_subscriber_submit_button.prop('disabled', true);
        } else {
            if (subscriber_confirm_checkbox.is(':checked')) {
                new_subscriber_submit_button.prop('disabled', false);
            }
        }
    });


    new_subscriber_submit_button.on('click', function() {

        var first_name = first_name_input.val();
        var last_name = last_name_input.val();
        var email = email_input.val();

        console.log(first_name + " " + last_name + " " + email);

        $.ajax({
            type:'POST',
            url: '/ajax_create_subscriber',
            dataType: "json",
            data: {
                app_id: app_id,
                first_name: first_name,
                last_name: last_name,
                email: email,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_subscriber_modal.modal('toggle');
            }
        });
        
    });

    batch_email_send_button.on('click', function(){

        var template = template_list_select.val();


        $.ajax({
            type:'POST',
            url:'/ajax_create_batch_email',
            dataType: "json",
            data: {
                app_id: app_id,
                email_template_id: template,
                email_list_id: email_list_id,
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

        new_batch_email_modal.modal('toggle');

    });

    $('#subscribers_table_length').on('change', function() {

        $('.left_col').height($('.right_col').height());
    });


    function init() {

        //Disable new Subscriber Submit Button
        new_subscriber_submit_button.prop('disabled', true);

        //Make Table jQuery Datatable instance
        subscribers_table.dataTable({
            "pageLength": 5,
            "lengthMenu": [[5, 10, 25], [5, 10, 25]],
            "columnDefs": [ {
                "targets": 'no-sort',
                "orderable": false
            } ]
        });

    }


});

/**
 * DeleteSubscriber Function
 * -------------------------
 * Calls API call to delete a subscriber from DB
 * and add them to the unsubscriber list
 *
 * @param id
 */
function deleteSubscriber(id) {

    $.ajax({
        type: 'POST',
        url: '/ajax_delete_subscriber',
        dataType: "json",
        data: {
            app_id: app_id,
            subscriber_id: id,
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


function viewSubscriberInfo(id) {

    if(clicked_view_info == 1){
        return;
    }
    clicked_view_info = 1;

    /* --- View Info Fields --- */
    var subscriber_view_id = $('#view_subscriber_id');
    var subscriber_view_first_name = $('#view_subscriber_first_name');
    var subscriber_view_last_name = $('#view_subscriber_last_name');
    var subscriber_view_email = $('#view_subscriber_email');
    var subscriber_view_revenue = $('#view_subscriber_revenue');
    var template_name = $('#templateName');
    var emails_clicked = $('#emailsClicked');
    var emails_opened = $('#emailsOpened');

    var email_table = $('#email_table');
    var no_emails_view = $('#no_emails_view');

    $.ajax({
        type:'POST',
        url:'/ajax_load_subscriber_info',
        dataType: "json",
        data: {
            app_id: app_id,
            subscriber_id: id,
            authenticity_token: csrf_token,

        },
        error: function(e) {
            console.log(e);
        },
        success: function(response) {
            $('#delete_subscriber_button').attr('onclick', 'deleteSubscriber(' + response.id + ')');
            subscriber_view_id.html(response.id);
            subscriber_view_first_name.html(response.first_name);
            subscriber_view_last_name.html(response.last_name);
            subscriber_view_email.html(response.email);
            subscriber_view_revenue.html("$" + parseFloat(response.revenue).toFixed(2));
            console.log(response);

            var obj = JSON.parse(response.emails);
            var list_obj = JSON.parse(response.lists);

            if(response.total_emails == 0){
                email_table.hide();
                no_emails_view.attr('class', '');
            } else {

                for (var i = 0; i < response.total_emails; i++) {
                    var html = "<tr>";
                    html = html + "<td>" + obj[i].name + "</td>";

                    if (obj[i].clicked === 1) {
                        html = html + "<td>" + "Yes" + "</td>";
                    } else {
                        html = html + "<td>" + "No" + "</td>";
                    }

                    if (obj[i].opened === 1) {
                        html = html + "<td>" + "Yes" + "</td>";
                    } else {
                        html = html + "<td>" + "No" + "</td>";
                    }

                    html = html + "</tr>";
                    $('#sub_table_body').append(html);
                }
            }

            for(var i = 0; i < response.total_lists; i++) {
                var html = "<tr>";
                html = html + "<td class='text-left' style='font-size: 28px'>" + list_obj[i].email_list_name + "</td>";
                html = html + "<td style='width: 100px;'>" + "<button onclick='removeSubscriber(" + response.id +"," + list_obj[i].email_list_id + ")' type='button' class='btn btn-danger btn-block'><i class='fa fa-trash-o'></i></button>" + "</td>";

                html = html + "</tr>";
                $('#list_table_body').append(html);
            }

        }

    });


}

function removeSubscriber(subscriber_id, list_id){
    var subscriber = subscriber_id;
    var list = list_id;

    $.ajax({
        type:'POST',
        url: '/ajax_remove_from_list',
        dataType: "json",
        data: {
            app_id: app_id,
            subscriber_id: subscriber,
            email_list_id: list,
            authenticity_token: csrf_token

        },
        error: function(e){
            console.log(e);
        },
        success: function(response){
            subscriber_info_modal.modal('toggle');
            console.log(response);
            window.location.reload(true);

        }



    });

}
