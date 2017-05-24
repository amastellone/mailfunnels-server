
$(function(){


    /* --- INPUT FIELDS --- */
    var emailTitleInput = $('#emailTitleInput');
    var emailContentInput = $('#emailContentInput');
    var buttonTextInput = $('#buttonTextInput');
    var addButtonDropDown = $('#addButtonDropDown');

    /* --- DIV Fields --- */
    var emailViewButtonFields = $('#emailViewButtonFields');


    /* --- Functions to live update EmailView --- */

    emailTitleInput.on("keyup", function(){
        $('#printEmailTitle').html(emailTitleInput.val());
    });

    emailContentInput.on("keyup", function(){
        $('#printEmailContent').html(emailContentInput.val());
    });

    buttonTextInput.on("keyup", function(){
        $('#printButtonText').html(buttonTextInput.val());
    });

    addButtonDropDown.on("change", function(){
        $('')


    });



});