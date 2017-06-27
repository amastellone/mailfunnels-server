$(function() {

    /* --- INPUT FIELDS --- */
    var login_username = $('#mf_login_username_input');
    var login_password = $('#mf_login_password_input');

    /* --- BUTTONS --- */
    var login_submit_button = $('#mf_login_submit_button');

    //Initialize the login page
    init();


    /**
     * On Login Username Input Change
     *
     * If input field is empty, disable the login button
     */
    login_username.on('change', function() {
        if ($(this).val() === '' || login_password.val() === '') {
            login_submit_button.prop('disabled', true);
        } else {
            login_submit_button.prop('disabled', false);
        }
    });


    /**
     * On Login Password Input Change
     *
     * If input field is empty, disable the login button
     */
    login_password.on('change', function() {
        if ($(this).val() === '' || login_username.val() === '') {
            login_submit_button.prop('disabled', true);
        } else {
            login_submit_button.prop('disabled', false);
        }
    });


    login_submit_button.on('click', function() {

        if (login_username.val() === '' || login_password.val() === '') {
            login_submit_button.prop('disabled', true);
        }

        $.ajax({
            type: 'POST',
            url: '/ajax_mf_user_auth',
            data: {
                mf_auth_username: login_username.val(),
                mf_auth_password: login_password.val()
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    window.location.href = "http://localhost:3000/login/?shop=" + response.url;
                }
            }

        });

    });


    /**
     * Initializes the Login Page
     *
     */
    function init() {

    }


});