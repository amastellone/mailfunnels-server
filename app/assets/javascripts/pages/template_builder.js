$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    var template_id = $('#current_template_id').val();
    var template_description = $('#current_description_value').val();

    var email_submit = $('#email_list_submit_button');

    var current_html = $('#current_html_value').val();

    var current_template_id = $('#mf_current_template_id_holder').val();
    var send_test_email_input = $('#mf_test_email_input');
    var send_test_email_submit = $('#mf_test_email_submit');
    var test_email_modal = $('#test_email_modal');
    var set_default_button = $('#mf-set-default');
    var default_template_modal = $('#mf-default-saved-modal');

    var template_settings_submit = $('#mf_template_submit_button');
    var template_settings_name = $('#mf_template_name_input');
    var template_settings_subject = $('#mf_template_subject_input');
    var template_settings_description = $('textarea#mf_template_description_input');



    init();


    set_default_button.on('click', function() {
        $.ajax({
            type:'POST',
            url: '/ajax/template/set_default_template',
            dataType: "json",
            data: {
                id: template_id,
                html: $('#contentarea').data('contentbuilder').html(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                default_template_modal.modal('toggle');
            }
        });
    });

    email_submit.on("click", function(e){

        e.preventDefault();

        $.ajax({
            type:'POST',
            url: '/ajax/template/save_email_template',
            dataType: "json",
            data: {
                id: template_id,
                html: $('#contentarea').data('contentbuilder').html(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.href = '/email_templates';
            }
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

    template_settings_submit.on('click', function() {
        
        var template_name_val = template_settings_name.val();
        var template_description_val = template_settings_description.val();
        var template_email_subject_val = template_settings_subject.val();


        $.ajax({
            type:'POST',
            url: '/ajax/template/update_template_info',
            dataType: "json",
            data: {
                template_id: template_id,
                name: template_name_val,
                description: template_description_val,
                email_subject: template_email_subject_val,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                $('#mf-template-settings-modal').modal('toggle');
                $('#mf-updated-settings-modal').modal('toggle');
            }
        });

    });

    /*
     USE THIS FUNCTION TO SELECT CUSTOM ASSET WITH CUSTOM VALUE TO RETURN
     An asset can be a file, an image or a page in your own CMS
     */
    function selectAsset(assetValue) {

        alert('Hello!');


        // Get selected URL
        var inp = parent.top.$('#active-input').val();
        alert(inp);
        parent.top.$('#' + inp).val(assetValue);

        //Close dialog
        // if (window.frameElement.id == 'ifrFileBrowse') parent.top.$("#md-fileselect").data('simplemodal').hide();
        // if (window.frameElement.id == 'ifrImageBrowse') parent.top.$("#md-imageselect").data('simplemodal').hide();
    }

    $('#mf-template-image-submit').on('click', function() {

        selectAsset($('#mf-template-image-input').val());
    });


    function init() {
        // $('.left_col').hide();


        template_settings_description.text(template_description);

        $("#contentarea").contentbuilder({
            snippetCustomCode: true,
            snippetFile: '/template_builder/assets/minimalist-basic/snippets.html',
            toolbar: 'left'
        });

        $("#contentarea").data('contentbuilder').loadHTML(current_html);

    }

});


function openTestEmailModal() {
    $('#test_email_modal').modal('toggle');
}

