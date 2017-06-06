$(function(){

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES INITIALIZATION --- */
    app_id = $('#current_app_id').val();


    /* --- FORM INPUT FIELDS --- */
    var first_name_input = $('#first_name_input');
    var last_name_input = $('#last_name_input');
    var email_input = $('#email_input');
    var street_address_input = $('#street_address_input');
    var city_input = $('#city_input');
    var zip_code_input = $('#zip_code_input');
    var state_input = $('#state_input');



    /* ---- BUTTONS --- */
    var save_account_info_button = $('#save_account_info_button');


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
            },
            success: function(response) {
                console.log(response);
                alert("SAVED!");
            }

        });






    });















});