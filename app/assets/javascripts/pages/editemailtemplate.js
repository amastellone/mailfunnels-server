
$(function(){


    /* --- APP VALUES --- */
    var template_id = $('#current_template_id').val();
    var old_content = $('#current_content_value').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- INPUT FIELDS --- */
    var email_subject_input = $('#email_subject_input');
    var emailTitleInput = $('#emailTitleInput');
    var emailContentInput = $('#email_content_input');
    var buttonTextInput = $('#buttonTextInput');
    var buttonLink = $('#buttonUrlInput');
    var button_select = $('#button_select');
    var button_form_div = $('#button_forms_div');

<<<<<<< HEAD

    /* --- DIV Fields --- */
    var emailViewButtonFields = $('#emailViewButtonFields');
    var showEmailButton = $('#showEmailButton');
=======
    /* --- EMAIL PREVIEW FIELDS --- */
    var preview_email_title = $('#printEmailTitle');
    var preview_email_content = $('#printEmailContent');
    var preview_email_button_text = $('#printButtonText');
    var preview_email_buttons_div = $('#preview_buttons_div');
>>>>>>> 91ec93ef6e2e50650b75fd73eb4138a6785193b4


    /* --- BUTTONS --- */
    var email_submit = $('#email_list_submit_button');


    /* --- INITIAL EDIT EMAIL SETUP --- */
    emailContentInput.val(old_content);
    preview_email_title.html(email_subject_input.val());
    preview_email_content.html(emailContentInput.val());
    preview_email_button_text.html(buttonTextInput.val());

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

    /* --- Functions to live update EmailView --- */

    emailTitleInput.on("keyup", function(){
        preview_email_title.html(emailTitleInput.val());
    });

    emailContentInput.on("keyup", function(){
        preview_email_content.html(emailContentInput.val());
    });

    buttonTextInput.on("keyup", function(){
        preview_email_button_text.html(buttonTextInput.val());
    });

    button_select.on("change", function(){

<<<<<<< HEAD
        if ($(this).val() === '0') {
            $('#emailViewButtonFields').attr('class', 'hidden');
            $('#showEmailButton').attr('class', 'hidden');
        } else {
            $('#emailViewButtonFields').attr('class', ' ');
            $('#showEmailButton').attr('class', ' ');
=======
        if ($(this).val() === "true") {
            preview_email_buttons_div.show();
            button_form_div.show();
        } else {
            preview_email_buttons_div.hide();
            button_form_div.hide();
>>>>>>> 91ec93ef6e2e50650b75fd73eb4138a6785193b4
        }
    });


    email_submit.on("click", function(e){

        e.preventDefault();

        var email_subject = email_subject_input.val();
        var email_title = emailTitleInput.val();
        var email_content = emailContentInput.val();
        var button_text = buttonTextInput.val();
        var button_url =  buttonLink.val();
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
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
            }
        });


    });






});