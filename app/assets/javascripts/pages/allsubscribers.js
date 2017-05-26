

$(function() {


    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- MODALS --- */
    var new_subscriber_modal = $('#new_subscriber_modal');

    /* --- INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');

    /* --- BUTTONS --- */
    var new_subscriber_submit_button = $('#new_subscriber_submit_button');



    new_subscriber_submit_button.on('click', function() {

        var first_name = first_name_input.val();
        var last_name = last_name_input.val();
        var email = email_input.val();

        console.log(first_name + " " + last_name + " " + email);

        new_subscriber_modal.modal('toggle');


    });


});