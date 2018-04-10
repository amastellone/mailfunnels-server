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

        $('#contentarea').find("img").attr('src', assetValue);

        toggleImageUploadModal();

        //Close dialog
        // if (window.frameElement.id == 'ifrFileBrowse') parent.top.$("#md-fileselect").data('simplemodal').hide();
        // if (window.frameElement.id == 'ifrImageBrowse') parent.top.$("#md-imageselect").data('simplemodal').hide();
    }

    $("#mf-template-image-submit").click(function () {

        data = new FormData();
        data.append("file", $('#mf-template-image-input')[0].files[0]);
        $.ajax({
            data: data,
            type: "POST",
            url: "/upload_image_to_aws",
            cache: false,
            contentType: false,
            processData: false,
            success: function(response) {
                console.log(response);
                selectAsset(response.url);

            }
        });
    });


    function toggleImageUploadModal() {

        $('#mf-image-select-modal').modal('toggle');

    }


    function init() {
        // $('.left_col').hide();


        template_settings_description.text(template_description);

        $("#contentarea").contentbuilder({
            snippetCustomCode: true,
            snippetFile: '/template_builder/assets/minimalist-basic/snippets.html',
            toolbar: 'left',
            onImageBrowseClick: function () {
                toggleImageUploadModal();
            },
            snippetCategories: [[0, "Default"],
                [-1, "All"],
                [36, "Done For You"],
                [1, "Titles"],
                [6, "Paragraphs"],
                [33, "Buttons"],
                [34, "Cards"],
                [11, "Images"],
                [13, "Call To Action"],
                [14, "Lists"],
                [15, "Quotes"],
                [17, "Maps"],
                [20, "Video"],
                [18, "Social Media"],
                [22, "Contact Info"],
                [23, "Pricing"],
                [24, "Team Profile"],
                [35, "Achievements & Skills"],
                [25, "Products/Portfolio"],
                [26, "How It Works"],
                [28, "As Featured On"],
                [30, "Coming Soon"],
                [19, "Separator"],
                [100, "Custom Code"],
            ]
        });

        $("#contentarea").data('contentbuilder').loadHTML(current_html);

    }

});


function openTestEmailModal() {
    $('#test_email_modal').modal('toggle');
}

