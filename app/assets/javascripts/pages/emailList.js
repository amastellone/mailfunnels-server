$(function(){

    $("body").tooltip({ selector: '[data-toggle=tooltip]' });


    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_email_list_modal = $('#new_email_list_modal');


    /* --- INPUT FIELDS --- */
    var listNameInput = $('#email_list_name_input');
    var listDescriptionInput = $('#email_list_description_input');

    /* --- BUTTONS --- */
    var emailListSubmit = $('#new_email_list_submit_button');


    emailListSubmit.on("click", function(e) {

        e.preventDefault();

        var listName = listNameInput.val();
        var description = listDescriptionInput.val();


        $.ajax({
            type:'POST',
            url: '/ajax_create_email_list',
            dataType: "json",
            data: {
                app_id: app_id,
                name: listName,
                description: description,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_email_list_modal.modal('toggle');
            }
        });

    });




});