/**
 * jQuery Handler for the FunnelBuilder Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */

$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var funnel_id = $('#current_funnel_id').val();

    /* --- FUNNEL BUILDER COMPONENTS --- */
    var funnel_builder = $('#funnel_builder');

    /* --- BUTTONS --- */
    var new_node_button = $('#create_button'); //Create New Job Button
    var delete_selected_button = $('#delete_selected_button'); //Campaign Job Delete Button
    var view_selected_node_button = $('#view_selected_button'); //Campaign Job Edit Button
    var submit_new_node_button = $('#new_node_submit_button'); //Add Node Form Submit Button

    /* --- FORM INPUTS --- */
    var new_node_label = $('#new_node_label_input');
    var new_node_email_template_select = $('#new_node_email_template_select');
    var new_node_delay_time_input = $('#new_node_delay_time_input');

    /* --- MODALS --- */
    var create_new_node_modal = $('#modal_node_create'); //New Job Modal
    var view_node_modal = $('#view_node_modal');

    /* --- VIEW INFO MODAL COMPONENTS --- */
    var node_view_name = $('#view_node_name');
    var node_view_email_template_name = $('#view_node_email_template_name');
    var node_view_delay_time = $('#view_node_delay_time');
    var node_view_total_emails = $('#view_node_total_emails');
    var node_view_emails_sent = $('#view_node_emails_sent');
    var node_view_emails_opened = $('#view_node_emails_opened');
    var node_view_emails_clicked = $('#view_node_emails_clicked');
    var node_view_total_revenue = $('#view_node_total_revenue');
    var node_view_email_settings_template = $('#view_node_email_settings_template');


    /* --- DYNAMIC VALUES --- */
    var isLoading = false;


    //Setup the initial funnel builder
    init();


    //On New Node Button Click
    new_node_button.click(function(event) {

        create_new_node_modal.modal('toggle');

    });

    submit_new_node_button.click(function() {

        var label = new_node_label.val();
        var email_template_id = new_node_email_template_select.val();
        var delay_time = new_node_delay_time_input.val();

        $.ajax({
            type:'POST',
            url: '/ajax_add_new_node',
            dataType: "json",
            data: {
                funnel_id: funnel_id,
                email_template_id: email_template_id,
                delay_time: delay_time,
                name: label,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
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
            }
        });

        create_new_node_modal.modal('toggle');
    });

    delete_selected_button.click(function() {
        funnel_builder.flowchart('deleteSelected');
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
                node_view_total_revenue.html(response.node_total_revenue);
                node_view_email_settings_template.html(response.email_template_name);
                console.log(response);
            }
        });


        view_node_modal.modal('toggle');

    });


    function init() {

        // Set loading to true
        isLoading = true;

        // Set the height of the funnel builder panel
        funnel_builder.css('min-height', $(window).height() - 200);

        //Hide the delete and edit selected buttons
        hideButtons();

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
            return;
        }

        //Otherwise, show the delete and edit button and change edit button data-node
        delete_selected_button.show();
        view_selected_node_button.show();

    }

    function hideButtons() {
        delete_selected_button.hide();
        view_selected_node_button.hide();
    }



});




