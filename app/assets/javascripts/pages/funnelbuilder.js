/**
 * jQuery Handler for the FunnelBuilder Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */
var new_node_email_template_select;
var current_template_id;
$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();
    var funnel_id = $('#current_funnel_id').val();
    var current_trigger_id = $('#current_trigger_id').val();
    var current_email_list_id = $('#current_list_id').val();
    // var new_email_template_id = $('#email_template_id');

    /* --- FUNNEL BUILDER COMPONENTS --- */
    var funnel_builder = $('#funnel_builder');

    /* --- BUTTONS --- */
    var funnel_activate_button = $('#funnel_activate_button');
    var funnel_deactivate_button = $('#funnel_deactivate_button');
    var new_node_button = $('#create_button'); //Create New Job Button
    var delete_selected_button = $('#delete_selected_button'); //Campaign Job Delete Button
    var view_selected_node_button = $('#view_selected_button'); //Campaign Job Edit Button
    var submit_new_node_button = $('#new_node_submit_button'); //Add Node Form Submit Button
    var preview_email_button = $('#preview_email_button'); //Preview Email Button
    var edit_node_button = $('#edit_selected_button'); // Edit Node Button
    var save_edit_node_button = $('#edit_node_submit_button'); // Saved Edited Node Button
    var view_template_button = $('#viewButton'); // View Template from node
    var edit_template_button = $('#editButton'); // Edit Template from node


    /* --- FORM INPUTS --- */
    var new_node_label = $('#new_node_label_input');
    new_node_email_template_select = $('#new_node_email_template_select');
    var new_node_delay_time_input = $('#new_node_delay_time_input');
    var time_unit_select = $('#time_unit_select');

    /* --- MODALS --- */
    var create_new_node_modal = $('#modal_node_create'); //New Job Modal
    var view_node_modal = $('#view_node_modal'); //View Node Info Modal
    var view_template_modal = $('#view_template_modal'); //Preview Email Modal
    var edit_node_modal = $('#modal_node_edit'); //Edit Node Modal
    var edit_funnel_modal = $('#edit_funnel_modal'); //Edit Funnel Modal

    var new_email_template_modal = $('#new_email_template_modal');



    /* --- VIEW INFO MODAL COMPONENTS --- */
    var node_view_name = $('#view_node_name');
    var node_view_email_template_name = $('#view_node_email_template_name');
    var node_view_delay_time = $('#view_node_delay_time');
    var node_view_total_emails = $('#view_node_total_emails');
    var node_view_emails_sent = $('#view_node_emails_sent');
    var node_view_emails_opened = $('#view_node_emails_opened');
    var node_view_emails_clicked = $('#view_node_emails_clicked');
    var node_view_email_settings_template = $('#view_node_email_settings_template');
    var node_view_email_description = $('#view_node_email_description');

    /* --- EDIT NODE MODAL COMPONENTS --- */
    var edit_node_label = $('#edit_node_label_input');
    var edit_node_email_template_select = $('#edit_node_email_template_select');
    var edit_node_delay_time_input = $('#edit_node_delay_time_input');
    var edit_node_time_unit_select = $('#edit_node_time_unit_select');

    /* --- EDIT FUNNEL MODAL COMPONENTS --- */
    var edit_funnel_name = $('#edit_funnel_name_input');
    var edit_funnel_description = $('#edit_funnel_description_input');
    var edit_funnel_trigger = $('#edit_funnel_trigger_select');
    var edit_funnel_email_list = $('#edit_funnel_email_list_select');
    var edit_funnel_submit_button = $('#edit_funnel_submit_button');


    /* --- New Email Template Components --- */
    var new_email_subject_input = $('#new_email_subject_input');
    var theme_color = $('#theme_color');
    var email_title_input = $('#email_title_input');
    var button_select = $('#button_select');
    var buttonTextInput = $('#buttonTextInput');
    var buttonUrlInput = $('#buttonUrlInput');

    var button_form_div = $('#button_form_div');

    var new_template_submit_button = $('#new_template_submit_button');




    var email_title = $('#printEmailTitle');
    var email_content = $('#printEmailContent');
    var button_text = $('#printButtonText');


    var summernote_content




    /* --- DYNAMIC VALUES --- */
    var isLoading = false;


    //Setup the initial funnel builder
    init();

    button_select.on('change', function(){

        if ($(this).val() === 'true') {

            button_form_div.show();
        } else {
            button_form_div.hide();
        }
    });


    edit_funnel_trigger.on('change', function() {

        if ($(this).val() === '0') {
            edit_funnel_submit_button.prop('disabled', true);
        } else {
            edit_funnel_submit_button.prop('disabled', false);
        }

    });

    /**
     * On Edit Funnel Form Submit Click
     *
     * Updates the info of the current funnel
     */
    edit_funnel_submit_button.on('click', function() {


        $.ajax({
            type: 'POST',
            url: '/ajax_update_funnel_info',
            data: {
                app_id: app_id,
                funnel_id: funnel_id,
                funnel_name: edit_funnel_name.val(),
                funnel_description: edit_funnel_description.val(),
                funnel_trigger_id: edit_funnel_trigger.val(),
                funnel_email_list_id: edit_funnel_email_list.val(),
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                window.location.reload();
            },
            success: function(response) {
                console.log(response);
                window.location.reload();
            }
        });


    });


    /**
     * On Funnel Activate Button Click
     *
     * Sets the funnel status to active
     *
     */
    funnel_activate_button.on('click', function() {

        $.ajax({
            type:'POST',
            url: '/ajax_activate_funnel',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
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
     * On Funnel Deactivate Button Click
     *
     * Sets the funnel status to inactive
     *
     */
    funnel_deactivate_button.on('click', function() {

        $.ajax({
            type:'POST',
            url: '/ajax_deactivate_funnel',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
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


    //On New Node Button Click
    new_node_button.click(function(event) {

        create_new_node_modal.modal('toggle');

    });

    submit_new_node_button.click(function() {

        var label = new_node_label.val();
        var email_template_id = new_node_email_template_select.val();
        var delay_time = new_node_delay_time_input.val();
        var delay_unit = time_unit_select.val();

        $.ajax({
            type:'POST',
            url: '/ajax_add_new_node',
            dataType: "json",
            data: {
                app_id: app_id,
                funnel_id: funnel_id,
                email_template_id: email_template_id,
                delay_time: delay_time,
                delay_unit: delay_unit,
                name: label,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
                create_new_node_modal.modal('toggle');
            },
            success: function(response) {
                console.log(response);
                var operatorId = response.id;
                var operatorData = {
                    top: 60,
                    left: 500,
                    properties: {
                        title: label,
                        class: 'flowchart-operator-email-node',
                        inputs: {
                            input_1: {
                                label: ' ',
                            }
                        },
                        outputs: {
                            output_1: {
                                label: ' ',
                            }
                        }
                    }
                };
                funnel_builder.flowchart('createOperator', operatorId, operatorData);
                current_template_id = response.email_template_id;
                create_new_node_modal.modal('toggle');
                if (email_template_id === '0') {
                    new_email_template_modal.modal('toggle');
                }

            }
        });



        edit_template_button.attr('href', 'edit_email_template/' + email_template_id);

    });


    new_template_submit_button.on('click', function(){
        var email_subject = new_email_subject_input.val();
        var color = theme_color.val();
        var email_title = email_title_input.val();
        var button_text = buttonTextInput.val();
        var button_url = buttonUrlInput.val();
        var content = $('#summernote').summernote('code');

        var has_button = false;

        if (button_select.val() === "true") {
            has_button = true;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_update_email_template',
            dataType: "json",
            data: {
                app_id: app_id,
                id: current_template_id,
                email_subject: email_subject,
                email_title: email_title,
                email_content: content,
                has_button: has_button,
                button_text: button_text,
                button_url: button_url,
                color: color,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                new_email_template_modal.modal('toggle');
            }
        });





    });

    delete_selected_button.click(function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');

        if (node_id === '0') {
            alert("Cannot Delete Start Node!");
            return;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_delete_node',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                funnel_builder.flowchart('deleteSelected');
            }
        });

    });


    view_selected_node_button.click(function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');

        $.ajax({
            type:'POST',
            url: '/ajax_load_node_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                node_view_name.html(response.node_name);
                node_view_email_template_name.html(response.email_template_name);
                node_view_delay_time.html(response.node_delay_time);
                node_view_total_emails.html(response.node_total_emails);
                node_view_emails_sent.html(response.node_emails_sent);
                node_view_emails_opened.html(response.node_emails_opened);
                node_view_emails_clicked.html(response.node_emails_clicked);
                node_view_email_settings_template.html(response.email_template_name);
                node_view_email_description.html(response.email_template_description);
                console.log(response);
            }
        });


        view_node_modal.modal('toggle');

    });


    //On Preview Button Click
    preview_email_button.on('click', function() {

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');


        $.ajax({
            type:'POST',
            url: '/ajax_load_email_template_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                email_title.html(response.email_title);
                $('#preview_email_greet').html(response.email_greet);
                email_content.html(response.email_content);
                button_text.html(response.button_text);
                button_text.css('background', response.color);
                $('#email_header').css('background', response.color);

                if (response.has_button === true) {
                    $('#preview_buttons_div').show();
                } else {
                    $('#preview_buttons_div').hide();
                }

                view_template_modal.modal('toggle');
                console.log(response);
            }
        });

    });




    edit_node_button.on('click', function(){

        edit_node_modal.modal('toggle');

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');


        $.ajax({

            type:'POST',
            url: '/ajax_load_node_edit_info',
            dataType: "json",
            data: {
                node_id: node_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                edit_node_label.val(response.node_name);
                edit_node_email_template_select.val(response.node_email_template_name);
                edit_node_delay_time_input.val(response.node_delay_time);
                edit_node_time_unit_select.val(response.node_delay_unit);
                console.log(response);
            }


        });


    });

    save_edit_node_button.on('click', function(){

        var node_id = funnel_builder.flowchart('getSelectedOperatorId');
        var node_name = edit_node_label.val();
        var email_template_id = edit_node_email_template_select.val();
        var delay_time = edit_node_delay_time_input.val();
        var time_unit = edit_node_time_unit_select.val();


        $.ajax({

            type:'POST',
            url: '/ajax_save_edit_node',
            dataType: "json",
            data: {
                id: node_id,
                name: node_name,
                email_template_id: email_template_id,
                delay_time: delay_time,
                delay_unit: time_unit,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response){
                edit_node_modal.modal('toggle');
                window.location.reload(true);
                console.log(response);

            }



        });




    });


    // new_template_submit_button.on('click', function(){
    //
    //
    //
    //
    //
    //
    //
    //
    //
    //
    // });



    
    /* ---- FUNNEL BUILDER FUNCTIONS --- */
    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

    function init() {

        // Set loading to true
        isLoading = true;

        // Set the height of the funnel builder panel
        funnel_builder.css('min-height', $(window).height() - 100);
        $('.left_col').height($('.right_col').height());

        //Hide the delete and edit selected buttons
        hideButtons();

        //Set Edit Funnel Values
        edit_funnel_description.val($('#current_funnel_description').val());
        edit_funnel_trigger.val(current_trigger_id);
        edit_funnel_email_list.val(current_email_list_id);

        //Fake Data For now, switch to live data later
        var data = {};

        $.ajax({
            type:'POST',
            url: '/ajax_load_funnel_json',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                //Start the flowchart plugin
                funnel_builder.flowchart({
                    verticalConnection: true,
                    data: response,
                    onOperatorSelect: function(operatorId) {
                        showButtons(operatorId);
                        return true;
                    },
                    onOperatorUnselect: function() {
                        hideButtons();
                        return true;
                    },
                    onOperatorMoved: function(operatorId) {
                        saveNodeLocation(operatorId);
                        return true;
                    },
                    onLinkCreate: function(linkId, linkData) {
                        saveNewLink(linkId, linkData);
                        return true;
                    }
                });

                // Set loading to false
                isLoading = false;

            }
        });


        if (button_select.val() === 'true') {
            button_form_div.show();

        } else {
            button_form_div.hide();
        }



        var summernote = $('#summernote');
        summernote.summernote({
            height: 200,
            toolbar: [
                // [groupName, [list of button]]
                ['style', ['bold', 'italic', 'underline', 'clear']],
                ['font', ['strikethrough', 'superscript', 'subscript']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']]
            ],
            shortcuts: false,
            dialogsInBody: true
        });

        $('.note-editable').css('font-size','13px');

        $('.note-editable').css('line-height', '1.0');



        //Set Color Picker to bootstrap color picker instance
        $('#theme_color_select').colorpicker();

    }




    /**
     * When a node of the funnel is moved, save the location
     * of the node by calling API call ajax_save_node
     *
     * @param operatorId
     */
    function saveNodeLocation(operatorId) {

        //If Flowchart is loading, return don't create link
        if (isLoading) {
            return;
        }

        if (operatorId === "0") {
            return;
        }

        var operatorData = funnel_builder.flowchart('getOperatorData', operatorId);

        console.log(operatorData);

        $.ajax({
            type:'POST',
            url: '/ajax_save_node',
            dataType: "json",
            data: {
                node_id: operatorId,
                top: operatorData.top,
                left: operatorData.left,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
            }
        });

    }

    /**
     * When a new link is created, save the link to the DB
     * by calling API call ajax_add_link
     *
     *
     * @param linkId
     * @param linkData
     */
    function saveNewLink(linkId, linkData) {

        //If Flowchart is loading, return don't create link
        if (isLoading) {
            return;
        }

        $.ajax({
            type:'POST',
            url: '/ajax_add_link',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
                from_operator_id: linkData.fromOperator,
                to_operator_id: linkData.toOperator,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
            }
        });
    }


    /**
     *
     * When a node is selected show the
     *
     * @param operatorID
     */
    function showButtons(operatorID) {

        if (operatorID === '0') {
            delete_selected_button.hide();
            view_selected_node_button.hide();
            preview_email_button.hide();
            edit_node_button.hide();
            return;
        }

        //Otherwise, show the delete and edit button and change edit button data-node
        delete_selected_button.show();
        view_selected_node_button.show();
        preview_email_button.show();
        edit_node_button.show();

    }

    function hideButtons() {
        delete_selected_button.hide();
        view_selected_node_button.hide();
        preview_email_button.hide();
        edit_node_button.hide()
    }




});




