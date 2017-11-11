
$(function(){


    /* --- APP VALUES --- */
    var template_id = $('#current_template_id').val();
    var old_content = $('#current_content_value').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- INPUT FIELDS --- */
    var email_subject_input = $('#email_subject_input');
    var emailTitleInput = $('#emailTitleInput');
    var buttonTextInput = $('#buttonTextInput');
    var buttonLink = $('#buttonUrlInput');
    var checkoutUrlSelect = $('#checkout_url_select');
    var button_select = $('#button_select');
    var button_form_div = $('#button_forms_div');
    var color_select = $('#color_select');
    //var theme_color_select = $('#theme_color_select');
    var theme_color = $('#theme_color');

    /* --- EMAIL PREVIEW FIELDS --- */
    var preview_email_title = $('#printEmailTitle');
    var preview_email_button_text = $('#printButtonText');
    var preview_email_buttons_div = $('#preview_buttons_div');
    var preview_email_header = $('#preview_header');

    /* --- EMAIL GREETING COMPONENTS --- */
    var greet_use_default = $('#mf_greet_default');
    var greet_set_div = $('#mf_greet_div');
    var greet_content = $('#mf_greet_content');
    var greet_cust_name_before = $('#mf_greet_before_cust_name');
    var greet_cust_name_after = $('#mf_greet_after_cust_name');

    var preview_greet_default = $('#mf_preview_def_greet');
    var preview_greet = $('#mf_preview_greet');
    var preview_greet_content = $('#preview_greet_content');
    var preview_greet_cust_before = $('#preview_greet_before');
    var preview_greet_cust_after = $('#preview_greet_after');

    /* --- BUTTONS --- */
    var email_submit = $('#email_list_submit_button');

    /* --- MODALS --- */
    var email_template_saved_modal = $('#email_template_saved_modal');



    //Initialize Edit Email Template Page
    init();

    /* --- Functions to live update EmailView --- */

    theme_color.on('change', function() {

        var color = $(this).val();

        preview_email_header.css('background', color);
        preview_email_button_text.css('background', color);


    });

    emailTitleInput.on("keyup", function(){
        preview_email_title.html(emailTitleInput.val());
    });


    buttonTextInput.on("keyup", function(){
        preview_email_button_text.html(buttonTextInput.val());
    });

    button_select.on('change', function(){

        if ($(this).val() === 'true') {
            preview_email_buttons_div.show();
            button_form_div.show();
        } else {
            preview_email_buttons_div.hide();
            button_form_div.hide();
        }
    });

    checkoutUrlSelect.on('change', function(){
        if (this.checked == true) {
            $(this).val(1);
            $("#buttonUrlInput").prop('disabled', true);
            $('#abandoned_text').show();
        } else {
            $(this).val(0);
            $("#buttonUrlInput").prop('disabled', false);
            $('#abandoned_text').hide();
        }
    });



    email_submit.on("click", function(e){

        e.preventDefault();

        var email_subject = email_subject_input.val();
        var email_title = emailTitleInput.val();
        var email_content =  $('#summernote').summernote('code');
        var button_text = buttonTextInput.val();
        var button_url =  buttonLink.val();
        var color = theme_color.val();
        var has_button = false;

        if (button_select.val() === "true") {
            has_button = true;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_update_email_template',
            dataType: "json",
            data: {
                id: template_id,
                email_subject: email_subject,
                email_title: email_title,
                email_content: email_content,
                has_button: has_button,
                button_text: button_text,
                button_url: button_url,
                color: color,
                has_checkout: checkoutUrlSelect.val(),
                greet_use_default: greet_use_default.val(),
                greet_content: greet_content.val(),
                greet_before_cust_name: greet_cust_name_before.val(),
                greet_after_cust_name: greet_cust_name_after.val(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                email_template_saved_modal.modal('toggle');
            }
        });


    });


    greet_content.on('keyup', function() {

        preview_greet_content.html($(this).val());

    });


    greet_use_default.on('change', function() {

        if (this.checked) {
            $(this).val(1);
            greet_set_div.attr('class', 'hidden');
            preview_greet_default.attr('class', '');
            preview_greet.attr('class', 'hidden');
        } else {
            $(this).val(0);
            greet_set_div.attr('class', '');
            preview_greet_default.attr('class', 'hidden');
            preview_greet.attr('class', '');

        }

    });


    greet_use_default.on('change', function() {

        if (this.checked) {
            $(this).val(1);
            greet_set_div.attr('class', 'hidden');
            preview_greet_default.attr('class', '');
            preview_greet.attr('class', 'hidden');
        } else {
            $(this).val(0);
            greet_set_div.attr('class', '');
            preview_greet_default.attr('class', 'hidden');
            preview_greet.attr('class', '');

        }

    });

    greet_cust_name_before.on('change', function() {
        if (this.checked) {
            $(this).val(1);
            greet_cust_name_after.attr('checked', false);
            greet_cust_name_after.val(0);
            preview_greet_cust_after.hide();
            preview_greet_cust_before.show();
        } else {
            $(this).val(0);
            greet_cust_name_after.val(0);
            preview_greet_cust_after.hide();
            preview_greet_cust_before.hide();
        }

    });


    greet_cust_name_after.on('change', function() {
        if (this.checked) {
            $(this).val(1);
            greet_cust_name_before.attr('checked', false);
            greet_cust_name_before.val(0);
            preview_greet_cust_before.hide();
            preview_greet_cust_after.show();
        } else {
            $(this).val(0);
            greet_cust_name_before.val(0);
            preview_greet_cust_after.hide();
            preview_greet_cust_before.hide();
        }

    });


    function init() {


        /* --- INITIAL EDIT EMAIL SETUP --- */
        preview_email_title.html(emailTitleInput.val());
        preview_email_button_text.html(buttonTextInput.val());
        color_select.val($('#current_color_value').val());

        //Set the Value of the Show Button Select from DB
        if ($('#show_button_value').val() === '1') {
            button_select.val('true');
        } else {
            button_select.val('false');
        }

        if (button_select.val() === 'true') {
            preview_email_buttons_div.show();
            button_form_div.show();

        } else {
            preview_email_buttons_div.hide();
            button_form_div.hide();
        }


        if (greet_use_default.val() === '1') {
            greet_use_default.attr('checked', true);
            greet_set_div.attr('class', 'hidden');
            preview_greet_default.attr('class', '');
            preview_greet.attr('class', 'hidden');

        } else {
            greet_use_default.attr('checked', false);
            greet_set_div.attr('class', '');
            preview_greet_default.attr('class', 'hidden');
            preview_greet.attr('class', '');
        }


        if (greet_cust_name_before.val() === '1') {
            greet_cust_name_before.attr('checked', true);
            preview_greet_cust_before.show();
        } else {
            greet_cust_name_before.attr('checked', false);
            preview_greet_cust_before.hide();
        }

        if (greet_cust_name_after.val() === '1') {
            greet_cust_name_after.attr('checked', true);
            preview_greet_cust_after.show();
        } else {
            greet_cust_name_after.attr('checked', false);
            preview_greet_cust_after.hide();
        }


        // set the value of checkout select from db
        if ($('#checkout_url_select').val() === '1') {
            checkout_url_select.checked = true;
            $("#buttonUrlInput").prop('disabled', true);
            $('#abandoned_text').show();
        } else {
            checkout_url_select.checked = false;
            $("#buttonUrlInput").prop('disabled', false);
            $('#abandoned_text').hide();
        }


        var summernote = $('#summernote');
        summernote.summernote({
            height: 200,
            toolbar: [
                // [groupName, [list of button]]
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']]
            ],
            shortcuts: false,
            dialogsInBody: true
        });


        summernote.summernote('code', old_content);

        $('.left_col').height($('.right_col').height());


        //Set Color Picker to bootstrap color picker instance
        $('#theme_color_select').colorpicker();
    }



});