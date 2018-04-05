$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    var template_id = $('#current_template_id').val();

    var email_submit = $('#email_list_submit_button');

    var current_html = $('#current_html_value').val();

    var current_template_id = $('#mf_current_template_id_holder').val();
    var send_test_email_input = $('#mf_test_email_input');
    var send_test_email_submit = $('#mf_test_email_submit');
    var test_email_modal = $('#test_email_modal');
    var set_default_button = $('#mf-set-default');
    var default_template_modal = $('#mf-default-saved-modal');



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


        $("#contentarea").contentbuilder({
            snippetCustomCode: true,
            snippetFile: '/template_builder/assets/minimalist-basic/snippets.html',
            toolbar: 'left',
        });

        $("#contentarea").data('contentbuilder').loadHTML(current_html);

    }

});