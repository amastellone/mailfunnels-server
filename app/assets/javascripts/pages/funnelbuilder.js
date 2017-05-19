/**
 * jQuery Handler for the FunnelBuilder Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */

$(function() {


    /* --- FUNNEL BUILDER COMPONENTS --- */
    var funnel_builder = $('#funnel_builder');


    /* --- BUTTONS --- */
    var new_job_button = $('#create_button'); //Create New Job Button
    var submit_new_trigger_button = $('#add_new_trigger_button');

    /* --- MODALS --- */
    var create_new_job_modal = $('#modal_node_create'); //New Job Modal

    // Set the height of the funnel builder panel
    funnel_builder.css('min-height', $(window).height() - 200);



        var data = {
            operators: {
                operator1: {
                    top: 20,
                    left: 20,
                    properties: {
                        title: 'Start',
                        class: 'flowchart-operator-start-node',
                        inputs: {},
                        outputs: {
                            output_1: {
                                label: ' ',
                            }
                        }
                    }
                },
                operator2: {
                    top: 80,
                    left: 300,
                    properties: {
                        title: 'Trigger 1',
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
                },
                operator3: {
                    top: 300,
                    left: 300,
                    properties: {
                        title: 'Trigger 2',
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
                },
            },
            links: {
                link1: {
                    fromOperator: 'operator1',
                    fromConnector: 'output_1',
                    toOperator: 'operator2',
                    toConnector: 'input_1',
                }

            }
        };

        // Apply the plugin on a standard, empty div...
        funnel_builder.flowchart({
            verticalConnection: true,
            data: data
        });


    //On New Job Button Click
    new_job_button.click(function(event) {

        create_new_job_modal.modal('toggle');

    });



    var operatorI = 0;
    submit_new_trigger_button.click(function() {


        var new_trigger_label = $('#new_trigger_label_input').val();


        var operatorId = 'created_operator_' + operatorI;
        var operatorData = {
            top: 60,
            left: 500,
            properties: {
                title: new_trigger_label,
                inputs: {
                    input_1: {
                        label: 'In',
                    }
                },
                outputs: {
                    output_1: {
                        label: 'Out',
                    }
                }
            }
        };

        operatorI++;

        funnel_builder.flowchart('createOperator', operatorId, operatorData);

        create_new_job_modal.modal('toggle');
    });



});



$('#delete_selected_button').click(function() {
    $('#example').flowchart('deleteSelected');
});
