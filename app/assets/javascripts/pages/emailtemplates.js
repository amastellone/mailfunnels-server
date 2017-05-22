/**
 * Created by lukehelminiak on 5/17/17.
 */
$(function(){

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_trigger_modal = $('#newEmailTemplateModal');

    /* --- INPUT FIELDS --- */
    var template_name_input = $('#template_name_input');
    var template_description_input = $('#template_description_input');
    var template_email_subject_input = $('#template_email_subject_input');
    var template_email_content_input = $('#template_email_content_input');

    /* --- BUTTONS --- */
    var new_template_submit = $('#new_template_submit_button');


    /**
     * Button On Click Function
     * ------------------------
     *
     * Function called when new funnel form is submitted
     * Retrieves input from fields and makes API call to
     * create a new trigger instance
     *
     */
    new_template_submit.on('click', function(e) {

        e.preventDefault();

        var template_name = template_name_input.val();
        var template_description = template_description_input.val();
        var template_email_subject = template_email_subject_input.val();
        var template_email_content = template_email_content_input.val();




        $.ajax({
            type:'POST',
            url: '/create_trigger',
            dataType: "json",
            data: {
                app_id: app_id,
                name: trigger_name,
                description: trigger_description,
                emailSubject: trigger_email_subject,
                emailContent: trigger_email_content,
                email_list_id: emailList,
                hook_id: hook,
                delay_time: delayTime,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                new_trigger_modal.modal('toggle');
            }
        });

    });


});
