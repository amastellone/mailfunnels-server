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

    /* --- MODALS --- */
    var create_new_job_modal = $('#modal_node_create'); //New Job Modal

    funnel_builder.css('min-height', $(window).height() - 200);

        var data = {
            operators: {
                operator1: {
                    top: 20,
                    left: 20,
                    properties: {
                        title: 'Start',
                        inputs: {},
                        outputs: {
                            output_1: {
                                label: 'Out',
                            }
                        }
                    }
                },
                operator2: {
                    top: 80,
                    left: 300,
                    properties: {
                        title: 'Trigger 1',
                        inputs: {
                            input_1: {
                                label: 'Input 1',
                            },
                            input_2: {
                                label: 'Input 2',
                            },
                        },
                        outputs: {
                            output_1: {
                                label: 'Output 1',
                            }
                        }
                    }
                },
                operator3: {
                    top: 300,
                    left: 300,
                    properties: {
                        title: 'Trigger 2',
                        inputs: {
                            input_1: {
                                label: 'Input 1',
                            },
                            input_2: {
                                label: 'Input 2',
                            },
                        },
                        outputs: {}
                    }
                },
            }
        };

        // Apply the plugin on a standard, empty div...
        funnel_builder.flowchart({
            data: data
        });


    //On New Job Button Click
    new_job_button.click(function(event) {

        create_new_job_modal.modal('show');

    });



});

var operatorI = 0;
$('#create_operator').click(function() {
    var operatorId = 'created_operator_' + operatorI;
    var operatorData = {
        top: 60,
        left: 500,
        properties: {
            title: 'Operator ' + (operatorI + 3),
            inputs: {
                input_1: {
                    label: 'Input 1',
                }
            },
            outputs: {
                output_1: {
                    label: 'Output 1',
                }
            }
        }
    };

    operatorI++;

    $('#example').flowchart('createOperator', operatorId, operatorData);
});

$('#delete_selected_button').click(function() {
    $('#example').flowchart('deleteSelected');
});
