$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    //Template Fields
    var template_id = parseInt($('#current_template_id').val());
    var template_description = $('#current_description_value').val();
    var current_html = $('#current_html_value').val();
    var is_template_dynamic = parseInt($('#current_dynamic_value').val());
    var has_ac_holder = parseInt($('#current_ac_value_holder').val());
    var current_template_id = $('#mf_current_template_id_holder').val();

    //Containers
    var product_select_container = $('#mf-test-email-product-select-cont');

    //Placeholders
    var product_select = $('#test_email_product_list_select');
    var product_select_name = $('#test_email_product_list_select_name');


    //Input Fields
    var send_test_email_input = $('#mf_test_email_input');
    var template_settings_name = $('#mf_template_name_input');
    var template_settings_subject = $('#mf_template_subject_input');
    var template_settings_description = $('textarea#mf_template_description_input');


    //Modals
    var template_saved_modal = $('#mf-template-saved-modal');
    var default_template_modal = $('#mf-default-saved-modal');
    var added_dynamic_template_modal = $('#mf-dynamic-holder-modal');
    var test_email_modal = $('#test_email_modal');
    var send_test_email_submit = $('#mf_test_email_submit');


    //Buttons
    var email_submit = $('#email_list_submit_button');
    var email_save_button = $('#template_save_button');
    var template_clear_button = $('#mf-template-clear-button');
    var test_email_select_product_button = $('#mf-test-email-select-product-btn');
    var set_default_button = $('#mf-set-default');
    var template_settings_submit = $('#mf_template_submit_button');




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

        $('.mf-dynamic-image-placeholder').attr('src', '{{product_image}}');


        $.ajax({
            type:'POST',
            url: '/ajax/template/save_email_template',
            dataType: "json",
            data: {
                id: template_id,
                html: $('#contentarea').data('contentbuilder').html(),
                dynamic: is_template_dynamic,
                has_ac_holder: has_ac_holder,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                $('.mf-dynamic-image-placeholder').attr('src', 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/store_placeholder.png');
            },
            success: function(response) {
                console.log(response);
                window.location.href = '/email_templates';
            }
        });

    });

    email_save_button.on('click', function(e) {

        e.preventDefault();

        $('.mf-dynamic-image-placeholder').attr('src', '{{product_image}}');


        $.ajax({
            type:'POST',
            url: '/ajax/template/save_email_template',
            dataType: "json",
            data: {
                id: template_id,
                html: $('#contentarea').data('contentbuilder').html(),
                dynamic: is_template_dynamic,
                has_ac_holder: has_ac_holder,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                $('.mf-dynamic-image-placeholder').attr('src', 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/store_placeholder.png');
            },
            success: function(response) {
                console.log(response);
                template_saved_modal.modal('toggle');
                $('.mf-dynamic-image-placeholder').attr('src', 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/store_placeholder.png');
            }
        });
    });

    send_test_email_submit.on('click', function() {

        console.log(product_select.attr('value'));

        $.ajax({
            type:'POST',
            url: '/ajax/template/send_test_email',
            dataType: "json",
            data: {
                email_template_id: current_template_id,
                to_email: send_test_email_input.val(),
                product_id: product_select.attr('value'),
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

    test_email_select_product_button.on('click', function() {


        var singleProductOptions = {
            'selectMultiple': false
        };

        ShopifyApp.Modal.productPicker(singleProductOptions, function(success, data) {
            // Callback is triggered any time a button
            // is clicked or the window is closed.

            if(success) {
                console.log(data);
                console.log(data.products[0]);
                sendTestProductSelected(data.products[0]);

            } else {
                return;
            }

            if (data.errors) {
                console.error(data.errors);
            }
        })

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


    template_clear_button.on('click', function(){
        $("#contentarea").data('contentbuilder').loadHTML("");
        is_template_dynamic = 0;
        has_ac_holder = 0;
        product_select_container.hide();
    });



    /*
     USE THIS FUNCTION TO SELECT CUSTOM ASSET WITH CUSTOM VALUE TO RETURN
     An asset can be a file, an image or a page in your own CMS
     */
    function selectAsset(assetValue) {

        console.log('here');

        $('.active-img-selected').attr('src', assetValue);

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

        console.log('here');

        $('#mf-image-select-modal').modal('toggle');

    }


    $(document).on({
        mouseenter: function () {

            if ($(this).attr('class') === 'mf-dynamic-image-placeholder') {
                console.log('DONT CHANGE');
                return;
            }
            console.log('mouse-over');
            $('.active-img-selected').attr('class', '');

            $(this).attr('class', 'active-img-selected');
        },
        mouseleave: function () {
            //stuff to do on mouse leave
        }
    }, '#contentarea img'); //pass the element as an argument to .on




    function init() {
        // $('.left_col').hide();

        if (is_template_dynamic === 0) {
            product_select_container.hide();
        }

        template_settings_description.text(template_description);

        $("#contentarea").contentbuilder({
            snippetCustomCode: true,
            snippetFile: '/template_builder/assets/minimalist-basic/snippets.html',
            toolbar: 'left',
            onImageBrowseClick: function () {
                console.log($(this));
                console.log($("#contentarea").find('#active-input').val());
                toggleImageUploadModal();
            },
            onDrop: function (event, ui) {
                // if (ui.item[0].dataset['cat'] === '37') {
                //     alert("hello!");
                // }
                console.log(ui.item[0].dataset);
                console.log(ui.item[0].dataset['cat']);  //custom script here

                if (ui.item[0].dataset['cat'] === '37') {
                    //Change Template To Dynamic
                    toggleDynamicTemplate();
                }

                if (ui.item[0].dataset['snip'] === '299') {
                    //Change Template AC Holder Value
                    toggleTemplateACHolder();
                }

            },
            snippetCategories: [[0, "Default"],
                [-1, "All"],
                [36, "Done For You"],
                [37, "Dynamic Cart"],
                [1, "Titles"],
                [6, "Paragraphs"],
                [33, "Buttons"],
                [34, "Cards"],
                [11, "Images"],
                [13, "Call To Action"],
                [14, "Lists"],
                [15, "Testimonials"],
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
                [100, "Custom Code"]
            ],
            customTags: [
                ["Subscriber First Name", "{{first_name}}"],
                ["Subscriber Last Name", "{{last_name}}"],
                ["Product Title", "{{product_title}}"],
                ["Product Description", "{{product_description}}"],
                ["Product Price", "{{product_price}}"],
                ["Product Image URL", "{{product_image}}"],
                ["Abandoned Checkout URL", "{{abandoned_checkout_url}}"]
            ],
        });

        $('.cb-icon-ticket').attr('class', 'cb-icon-ticket mf_blue');

        $("#contentarea").data('contentbuilder').loadHTML(current_html);

        $('.mf-dynamic-image-placeholder').attr('src', 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/store_placeholder.png');

    }



    function toggleDynamicTemplate() {
        added_dynamic_template_modal.modal('toggle');
        is_template_dynamic = 1;
        product_select_container.show();

    }

    function toggleTemplateACHolder() {
        has_ac_holder = 1;
    }

    function sendTestProductSelected(product) {

        product_select.attr('value', product.id);
        product_select_name.attr('value', product.title);

        if (product_select.val() !== '') {
            test_email_select_product_button.html("Product: " + product.title);
        }


    }



});


function openTestEmailModal() {
    $('#test_email_modal').modal('toggle');
}



