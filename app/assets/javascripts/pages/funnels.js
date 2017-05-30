/**
 * jQuery Handler for the Funnels Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */

$(function() {

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- MODALS --- */
    var new_funnel_modal = $('#newFunnelModal');

    /* --- INPUT FIELDS --- */
    var funnel_name_input = $('#funnel_name_input');
    var funnel_description_input = $('#funnel_description_input');
    var funnel_trigger_select = $('#funnel_trigger_select');
    var funnel_email_list_select = $('#funnel_email_list_select');

    /* --- BUTTONS --- */
    var new_funnel_submit = $('#new_funnel_submit_button');


    //Disable Submit Button on Form until a list and trigger is selected
    new_funnel_submit.prop("disabled",true);


    funnel_trigger_select.on('change', function() {

        var currentValue = $(this).val();
        if (funnel_email_list_select.val() != '0' && currentValue != '0') {
            new_funnel_submit.prop('disabled', false);
        } else {
            new_funnel_submit.prop('disabled', true);
        }

    });

    funnel_email_list_select.on('change', function() {

        var currentValue = $(this).val();
        if (funnel_trigger_select.val() != '0' && currentValue != '0') {
            new_funnel_submit.prop('disabled', false);
        } else {
            new_funnel_submit.prop('disabled', true);
        }


    });



    /**
     * Button On Click Function
     * ------------------------
     *
     * Function called when new funnel form is submitted
     * Retrieves input from fields and makes API call to
     * create a new funnel instance
     *
     */
    new_funnel_submit.on('click', function(e) {

        e.preventDefault();

        var funnel_name = funnel_name_input.val();
        var funnel_description = funnel_description_input.val();
        var funnel_trigger_id = funnel_trigger_select.val();
        var funnel_email_list_id = funnel_email_list_select.val();


        $.ajax({
            type:'POST',
            url: '/create_funnel',
            dataType: "json",
            data: {
                app_id: app_id,
                trigger_id: funnel_trigger_id,
                email_list_id: funnel_email_list_id,
                name: funnel_name,
                description: funnel_description,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_funnel_modal.modal('toggle');

            }
        });

    });






});