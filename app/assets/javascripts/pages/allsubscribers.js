/* --- APP VALUES DECLARATIONS --- */
var csrf_token;
var app_id;
var email_list_id;

$(function() {


    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();
    email_list_id = $('#current_email_list_id').val();


    /* --- MODALS --- */
    var new_subscriber_modal = $('#new_subscriber_modal');
    var new_batch_email_modal = $('#new_batch_email_modal');
    var subscriber_info_modal = $('#subscriber_info_modal');

    /* --- INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var template_list_select = $('#template_list_select');
    var email_list_name = $('#email_list_name');
    var subscriber_confirm_checkbox = $('#subscriber_confirm_checkbox');


    /* --- BUTTONS --- */
    var new_subscriber_submit_button = $('#new_subscriber_submit_button');
    var batch_email_send_button = $('#batch_email_send_button');
    var view_subscriber_info_button = $('#view_subscriber_info_button');





    //Initialize the Page
    init();


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
        $('#subscribers_table').dataTable({
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


    /* --- View Info Fields --- */
    var subscriber_view_id = $('#view_subscriber_id');
    var subscriber_view_first_name = $('#view_subscriber_first_name');
    var subscriber_view_last_name = $('#view_subscriber_last_name');
    var subscriber_view_email = $('#view_subscriber_email');
    var subscriber_view_revenue = $('#view_subscriber_revenue');
    var template_name = $('#templateName');
    var emails_clicked = $('#emailsClicked');
    var emails_opened = $('#emailsOpened');

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
            subscriber_view_revenue.html("$" + response.revenue);


            $.each(response.emails, function(email) {
                    var html = "<tr>";
                    html = html + "<td>" + email.name + "</td>";
                    //emails_clicked.html(response.clicked);
                    //emails_opened.html(response.opened);
                    html = html + "</tr>";
                    $('#sub_table_body').append(html);

            });

            for(i = 0; i < response.total_emails; i++) {

            }

            console.log(response);
        }

    });


}
