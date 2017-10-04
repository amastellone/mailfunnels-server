$(function() {


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- Dashboard Hidden Total Values --- */
    var total_emails_sent = $('#total_emails_sent');
    var total_emails_opened = $('#total_emails_opened');
    var total_emails_clicked = $('#total_emails_clicked');

    /* --- Dashboard Hidden Day Values --- */
    var num_emails_sent_day = $('#num_emails_sent_day');
    var num_emails_opened_day = $('#num_emails_opened_day');
    var num_emails_clicked_day = $('#num_emails_clicked_day');

    /* --- Dashboard Hidden Week Values --- */
    var num_emails_sent_week = $('#num_emails_sent_week');
    var num_emails_opened_week = $('#num_emails_opened_week');
    var num_emails_clicked_week = $('#num_emails_clicked_week');

    /* --- Dashboard Hidden Month Values --- */
    var num_emails_sent_month = $('#num_emails_sent_month');
    var num_emails_opened_month = $('#num_emails_opened_month');
    var num_emails_clicked_month = $('#num_emails_clicked_month');

    /* --- Dashboard Total Stats Components --- */
    var total_emails_opened_div = $('#emails_opened_div');
    var total_emails_clicked_div = $('#emails_clicked_div');
    var total_emails_opened_view = $('#emails_opened_view');
    var total_emails_clicked_view = $('#emails_clicked_view');

    /* --- Dashboard Time Stats Components --- */
    var new_subscribers_day = $('#new_subscribers_day');
    var unsubscribers_day = $('#unsubscribers_day');
    var emails_sent_day = $('#emails_sent_day');
    var emails_opened_day = $('#emails_opened_day');
    var emails_clicked_day = $('#emails_clicked_day');

    var new_subscribers_week = $('#new_subscribers_week');
    var unsubscribers_week = $('#unsubscribers_week');
    var emails_sent_week = $('#emails_sent_week');
    var emails_opened_week = $('#emails_opened_week');
    var emails_clicked_week = $('#emails_clicked_week');

    var new_subscribers_month = $('#new_subscribers_month');
    var unsubscribers_month = $('#unsubscribers_month');
    var emails_sent_month = $('#emails_sent_month');
    var emails_opened_month = $('#emails_opened_month');
    var emails_clicked_month = $('#emails_clicked_month');

    var num_revenue_day = $('#revenue_day');
    var num_revenue_week = $('#revenue_week');
    var num_revenue_month = $('#revenue_month');



    //Initialize the Home Page
    init();

    /* ----- ON HOVER FUNCTIONS ----- */

    /**
     * On Total Emails Opened Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    total_emails_opened_div.hover(function() {

        var percent = ((total_emails_opened.val() / total_emails_sent.val()) * 100).toFixed(2) + '%';

        if (total_emails_sent.val() === '0') {
            total_emails_opened_view.html('0.00%');
        } else {
            total_emails_opened_view.html(percent);
        }

    }, function() {

        total_emails_opened_view.html(total_emails_opened.val());

    });

    /**
     * On Total Emails Opened Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    total_emails_clicked_div.hover(function() {

        var percent = ((total_emails_clicked.val() / total_emails_sent.val()) * 100).toFixed(2) + '%';

        if (total_emails_sent.val() === '0') {
            total_emails_clicked_view.html('0.00%');
        } else {
            total_emails_clicked_view.html(percent);
        }

    }, function() {

        total_emails_clicked_view.html(total_emails_clicked.val());

    });


    /**
     * On Emails Opened For Day Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_opened_day.hover(function() {

        var percent = ((num_emails_opened_day.val() / num_emails_sent_day.val()) * 100).toFixed(2) + '%';


        if (num_emails_sent_day.val() === '0') {
            emails_opened_day.html('0.00%');
        } else {
            emails_opened_day.html(percent);
        }


    }, function() {

        emails_opened_day.html(num_emails_opened_day.val());

    });

    /**
     * On Emails Clicked For Day Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_clicked_day.hover(function() {

        var percent = ((num_emails_clicked_day.val() / num_emails_sent_day.val()) * 100).toFixed(2) + '%';


        if (num_emails_sent_day.val() === '0') {
            emails_clicked_day.html('0.00%');
        } else {
            emails_clicked_day.html(percent);
        }

    }, function() {

        emails_clicked_day.html(num_emails_clicked_day.val());

    });


    /**
     * On Emails Opened For Week Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_opened_week.hover(function() {

        var percent = ((num_emails_opened_week.val() / num_emails_sent_week.val()) * 100).toFixed(2) + '%';

        if (num_emails_sent_week.val() === '0') {
            emails_opened_week.html('0.00%');
        } else {
            emails_opened_week.html(percent);
        }

    }, function() {

        emails_opened_week.html(num_emails_opened_week.val());

    });

    /**
     * On Emails Clicked For Week Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_clicked_week.hover(function() {

        var percent = ((num_emails_clicked_week.val() / num_emails_sent_week.val()) * 100).toFixed(2) + '%';

        if (num_emails_sent_week.val() === '0') {
            emails_clicked_week.html('0.00%');
        } else {
            emails_clicked_week.html(percent);
        }

    }, function() {

        emails_clicked_week.html(num_emails_clicked_week.val());

    });

    /**
     * On Emails Opened For Month Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_opened_month.hover(function() {

        var percent = ((num_emails_opened_month.val() / num_emails_sent_month.val()) * 100).toFixed(2) + '%';

        if (num_emails_sent_month.val() === '0') {
            emails_opened_month.html('0.00%');
        } else {
            emails_opened_month.html(percent);
        }

    }, function() {

        emails_opened_month.html(num_emails_opened_month.val());

    });

    /**
     * On Emails Clicked For Day Hover
     * ------------------------------
     *
     * Changes value to percentage when hovered over
     */
    emails_clicked_month.hover(function() {

        var percent = ((num_emails_clicked_month.val() / num_emails_sent_month.val()) * 100).toFixed(2) + '%';

        if (num_emails_sent_day.val() === '0') {
            emails_clicked_month.html('0.00%');
        } else {
            emails_clicked_month.html(percent);
        }

    }, function() {

        emails_clicked_month.html(num_emails_clicked_month.val());

    });


    /**
     * @Function init()
     *
     * Initializes the dashboard statistics page
     *
     */
    function init() {
        $.ajax({

            type:'POST',
            url: '/ajax_load_time_data',
            dataType: "json",
            data: {
                app_id: app_id,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);

            },
            success: function(response) {
                console.log(response);

                //Change Subscriber Stats
                new_subscribers_day.html('' + response.today_subscribers);
                new_subscribers_week.html(response.week_subscribers);
                new_subscribers_month.html(response.month_subscribers);

                //Change Unsubscriber Stats
                unsubscribers_day.html(response.today_unsubscribers);
                unsubscribers_week.html(response.week_unsubscribers);
                unsubscribers_month.html(response.month_unsubscribers);

                //Change Emails Sent Stats
                emails_sent_day.html(response.today_emails_sent);
                num_emails_sent_day.val(response.today_emails_sent);
                emails_sent_week.html(response.week_emails_sent);
                num_emails_sent_week.val(response.week_emails_sent);
                emails_sent_month.html(response.month_emails_sent);
                num_emails_sent_month.val(response.month_emails_sent);


                //Change Emails Opened Stats
                emails_opened_day.html(response.today_emails_opened);
                num_emails_opened_day.val(response.today_emails_opened);
                emails_opened_week.html(response.week_emails_opened);
                num_emails_opened_week.val(response.week_emails_opened);
                emails_opened_month.html(response.month_emails_opened);
                num_emails_opened_month.val(response.month_emails_opened);


                // Change Emails Clicked Stats
                emails_clicked_day.html(response.today_emails_clicked);
                num_emails_clicked_day.val(response.today_emails_clicked);
                emails_clicked_week.html(response.week_emails_clicked);
                num_emails_clicked_week.val(response.week_emails_clicked);
                emails_clicked_month.html(response.month_emails_clicked);
                num_emails_clicked_month.val(response.month_emails_clicked);

                // Change Revenue Stats
                num_revenue_day.html(response.today_revenue);
                num_revenue_week.html(response.week_revenue);
                num_revenue_month.html(response.month_revenue);


            }

        });



    }




});
