/**
 * Created by lukehelminiak on 5/17/17.
 */
$(function(){

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_template_modal = $('#newEmailTemplateModal');
    var confirm_delete_modal = $('#confirm_delete_modal');
    var clone_template_modal = $('#mf-clone-template-modal');

    /* --- INPUT FIELDS --- */
    var template_name_input = $('#template_name_input');
    var template_description_input = $('#template_description_input');
    var template_email_subject_input = $('#template_email_subject_input');
    var clone_name_input = $('#mf_clone_name_input');
    var clone_description_input = $('#mf_clone_description_input');
    var clone_subject_input = $('#mf_clone_subject_input');

    /* --- BUTTONS --- */
    var new_template_submit = $('#new_template_submit_button');
    var delete_template_button = $('.delete_template_button');
    var confirm_delete_template_button = $('#confirm_delete_template_button');
    var clone_template_submit_button = $('#mf_clone_submit_button');


    var current_template_id = $('#mf_current_template_id_holder').val();
    var send_test_email_input = $('#mf_test_email_input');
    var send_test_email_submit = $('#mf_test_email_submit');
    var test_email_modal = $('#test_email_modal');

    var use_new_template_checkbox = $('#mf-template-new-style');


    init();


    $('.mf-clone-template').on('click', function() {

        var template_id = $(this).data('id');

        clone_template_submit_button.attr('data-id', template_id);

        clone_template_modal.modal('toggle');


    });

    use_new_template_checkbox.on('change', function() {
        if (this.checked) {
            $(this).val(1);
        } else {
            $(this).val(0);
        }
    });

    clone_template_submit_button.on('click', function() {

        var template_id = $(this).attr('data-id');

        var template_name = clone_name_input.val();
        var template_description = clone_description_input.val();
        var template_email_subject = clone_subject_input.val();


        $.ajax({
            type:'POST',
            url: '/ajax/template/clone_template',
            dataType: "json",
            data: {
                template_id: template_id,
                name: template_name,
                description: template_description,
                email_subject: template_email_subject,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload();
            }
        });

    });


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

        $.ajax({
            type:'POST',
            url: '/ajax_create_email_template',
            dataType: "json",
            data: {
                app_id: app_id,
                name: template_name,
                description: template_description,
                email_subject: template_email_subject,
                use_builder: use_new_template_checkbox.val(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_template_modal.modal('toggle');
            }
        });

    });


    delete_template_button.on('click', function() {

        var id = $(this).data('id');

        confirm_delete_modal.modal('toggle');


        confirm_delete_template_button.on('click', function(){


            $.ajax({
                type:'POST',
                url: '/ajax_delete_template',
                dataType: "json",
                data: {
                    template_id: id,
                    authenticity_token: csrf_token
                },
                error: function(e) {
                    console.log(e);
                },
                success: function(response) {
                    confirm_delete_modal.modal('toggle');
                    console.log(response);
                    window.location.reload(true);
                }
            });

        });

    });

    send_test_email_submit.on('click', function() {

        $.ajax({
            type:'POST',
            url: '/ajax/template/send_test_email',
            dataType: "json",
            data: {
                email_template_id: current_template_id,
                to_email: send_test_email_input.val(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                test_email_modal.modal('toggle');

            }
        });

    });

    function init() {

        use_new_template_checkbox.val(0);

        $('.left_col').height($('.right_col').height() + 100);

    }




});
