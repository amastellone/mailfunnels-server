
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