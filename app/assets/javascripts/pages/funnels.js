/**
 * jQuery Handler for the Funnels Page
 *
 * @Author Matt Twardowski <mttwardowski@gmail.com>
 *
 * @Version 1.0
 */

$(function() {

    /* --- MODALS --- */
    var new_funnel_modal = $('#newFunnelModal');

    /* --- INPUT FIELDS --- */
    var funnel_name_input = $('#funnel_name_input');
    var funnel_description_input = $('#funnel_description_input');

    /* --- BUTTONS --- */
    var new_funnel_submit = $('#new_funnel_submit_button');


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

        console.log("FUNNEL NAME: " + funnel_name);
        console.log("FUNNEL DESCRIPTION: " + funnel_description);

        new_funnel_modal.modal('toggle');

    });






});