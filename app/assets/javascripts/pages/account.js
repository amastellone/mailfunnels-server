$(function(){

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();


    /* --- ACCOUNT FORM INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var street_address_input = $('#street_address_input');
    var city_input = $('#city_input');
    var zip_code_input = $('#zip_code_input');
    var state_input = $('#state_input');
    var change_password_input = $('#mf_change_password_input');
    var change_password_confirm_input = $('#mf_confirm_password_input');

    /* --- EMAIL FORM INPUT FIELDS --- */
    var from_email_input = $('#from_email_input');
    var from_name_input = $('#from_name_input');

    /* ---- BUTTONS --- */
    var save_account_info_button = $('#save_account_info_button');
    var save_email_info_button = $('#save_email_info_button');
    var change_password_submit = $('#mf_change_password_submit');


    //Initialize the My Account Page
    init();


    change_password_input.on('keyup', function() {

        //If Password and Confirm Password don't match
        if ($(this).val() !== change_password_confirm_input.val()) {
            change_password_submit.prop('disabled', true);
        }

        //Check to see if they aren't empty
        if ($(this).val() === '' || change_password_confirm_input.val() === '') {
            change_password_submit.prop('disabled', true);
        } else {
            change_password_submit.prop('disabled', false);
        }

    });

    change_password_confirm_input.on('keyup', function() {

        //If Password and Confirm Password don't match
        if ($(this).val() !== change_password_input.val()) {
            change_password_submit.prop('disabled', true);
        }

        //Check to see if they aren't empty
        if ($(this).val() === '' || change_password_input.val() === '') {
            change_password_submit.prop('disabled', true);
        } else {
            change_password_submit.prop('disabled', false);
        }
    });


    save_account_info_button.on('click', function(e) {

        var first_name = first_name_input.val();
        var last_name = last_name_input.val();
        var email = email_input.val();
        var street_address = street_address_input.val();
        var city = city_input.val();
        var zip = zip_code_input.val();
        var state = state_input.val();

        $.ajax({
            type:'POST',
            url: '/ajax_update_account_info',
            dataType: "json",
            data: {
                id: app_id,
                first_name: first_name,
                last_name: last_name,
                email: email,
                street_address: street_address,
                city: city,
                zip: zip,
                state: state,
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


    save_email_info_button.on('click', function(e){

        var from_email = from_email_input.val();
        var from_name = from_name_input.val();

        $.ajax({
            type:'POST',
            url: '/ajax_update_email_info',
            dataType: "json",
            data: {
                id: app_id,
                from_email: from_email,
                from_name: from_name,
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

    change_password_submit.on('click', function() {

        //If Password and Confirm Password don't match
        if (change_password_input.val() !== change_password_confirm_input.val()) {
            change_password_submit.prop('disabled', true);
            return;
        }

        //Check to see if they aren't empty
        if (change_password_input.val() === '' || change_password_confirm_input.val() === '') {
            change_password_submit.prop('disabled', true);
            return;
        }


        //AJAX call to update user password
        $.ajax({
            type: 'POST',
            url: '/ajax_change_password',
            data: {
                app_id: app_id,
                password: change_password_input.val(),
                confirm: change_password_confirm_input.val()
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


    /**
     * Function that initializes the My Account Page
     *
     */
    function init() {

        //Disable the change Password Button
        change_password_submit.prop('disabled', true);

    }


});