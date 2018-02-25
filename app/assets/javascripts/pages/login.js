$(function() {

    /* ---- ENV VALUES ---- */
    const ENV_TYPE_DEV = 1;
    const ENV_TYPE_PROD = 2;
    const PROD_URL = "https://www.mailfunnels.io/login?shop=";
    const DEV_URL = "http://localhost:3000/login/?shop=";
    var CURR_ENV_TYPE;

    /* --- MESSAGES --- */
    var invalid_credential_message = $('#invalid_login_credentials_message');
    var server_error_message = $('#server_error_message');

    var reset_pass_email_sent = $('#reset-pass-sent');
    var reset_pass_email_sent_content = $('#reset-pass-sent-content');

    /* --- INPUT FIELDS --- */
    var login_username = $('#mf_login_username_input');
    var login_password = $('#mf_login_password_input');
    var shopify_domain_input = $('#mf_shopify_domain_input');
    var mf_reset_pass_email = $('#mf-reset-pass-email');

    /* --- BUTTONS --- */
    var login_submit_button = $('#mf_login_submit_button');
    var shopify_account_submit_button = $('#mf_auth_setup_submit_button');
    var mf_reset_pass_submit_button = $('#mf-reset-pass-submit');


    //Initialize the login page
    init();


    /**
     * On Login Username Input Change
     *
     * If input field is empty, disable the login button
     */
    login_username.on('keyup', function() {
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
    login_password.on('keyup', function() {
        if ($(this).val() === '' || login_username.val() === '') {
            login_submit_button.prop('disabled', true);
        } else {
            login_submit_button.prop('disabled', false);
        }
    });


    shopify_domain_input.on('keyup', function() {
        if ($(this).val() === '') {
            shopify_account_submit_button.prop('disabled', true);
        } else {
            shopify_account_submit_button.prop('disabled', false);
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
                server_error_message.show();
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    if (response.type === 1) {
                        shopify_account_submit_button.attr('data-id', response.user_id);
                        window.location.href = '#signup';
                    } else {
                        if (CURR_ENV_TYPE === ENV_TYPE_PROD) {
                            window.location.href = PROD_URL + response.url;
                        } else if (CURR_ENV_TYPE === ENV_TYPE_DEV) {
                            window.location.href = DEV_URL + response.url;
                        } else {
                            console.log("ERROR: NO ENVIRONMENT SET");
                            server_error_message.show();
                        }
                    }
                } else {
                    invalid_credential_message.show();
                }
            }

        });

    });

    shopify_account_submit_button.on('click', function() {

        if (shopify_domain_input.val() === '') {
            shopify_account_submit_button.prop('disabled', true);
        }

        var user_id = $(this).data('id');


        $.ajax({
            type: 'POST',
            url: '/ajax_mf_app_create',
            data: {
                user_id: user_id,
                domain: shopify_domain_input.val()
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                if (response.success === true) {
                    if (CURR_ENV_TYPE === ENV_TYPE_PROD) {
                        window.location.href = PROD_URL + response.url;
                    } else if (CURR_ENV_TYPE === ENV_TYPE_DEV) {
                        window.location.href = DEV_URL + response.url;
                    } else {
                        console.log("ERROR: NO ENVIRONMENT SET");
                        server_error_message.show();
                    }
                }
            }
        });

    });

    mf_reset_pass_submit_button.on('click', function() {

        //Get Email Input
        var email = mf_reset_pass_email.val();

        $.ajax({
            type: 'POST',
            url: '/mf_user_reset_password',
            data: {
                email: email
            },
            error: function(e) {
                console.log(e);
                reset_pass_email_sent_content.html("Sorry, we could not find an account with the email provided. Please try again.");
                reset_pass_email_sent.show();
            },
            success: function(response) {
                console.log(response);
                $('#reset-pass-content').hide();
                reset_pass_email_sent_content.html(response.message);
                reset_pass_email_sent.show();

                    $.ajax({
                        type: 'POST',
                        url: 'http://localhost:3001/send_reset_password_email',
                        data: {
                            email: email
                        },
                        error: function(e) {
                            console.log(e);
                            reset_pass_email_sent_content.html("Sorry, we could not find an account with the email provided. Please try again.");
                            reset_pass_email_sent.show();
                        },
                        success: function(response) {
                            console.log(response);
                        }
                    });

            }
        });



    });


    /**
     * Initializes the Login Page
     *
     */
    function init() {

        CURR_ENV_TYPE = ENV_TYPE_DEV;


        window.location.href = '#signin';

        reset_pass_email_sent.hide();



        //Disable Shopify Account Submit Button
        shopify_account_submit_button.prop('disabled', true);

        //Hide Error Messages
        invalid_credential_message.hide();
        server_error_message.hide();

    }


});