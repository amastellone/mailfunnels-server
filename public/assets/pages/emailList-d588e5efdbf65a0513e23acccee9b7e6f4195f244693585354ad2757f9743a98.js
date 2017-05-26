$(function(){


    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');


    /* --- INPUT FIELDS --- */
    var listNameInput = $('#email_list_name_input');
    var listDiscriptionInput = $('#email_list_description_input');

    /* --- BUTTONS --- */
    var emailListSubmit = $('#new_email_list_submit_button');


    emailListSubmit.on("click", function(e){

        e.preventDefault();

        var listName = listNameInput.val();
        var description = listDiscriptionInput.val();



        $.ajax({
            type:'POST',
            url: '/ajax_update_email_template',
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
            }
        });







    });




});
