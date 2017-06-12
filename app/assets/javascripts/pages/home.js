$(function() {


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- Dashboard Hidden Inputs --- */
    var num_emails_sent_day = $('#num_emails_sent_day');
    var num_emails_opened_day = $('#num_emails_opened_day');

    /* --- View Dashboard Info Components --- */
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


    //Initialize the Home Page
    init();



    emails_opened_day.hover(function() {

        var percent = (num_emails_sent_day.val() / num_emails_opened_day.val()) * 100;

        emails_opened_day.html(percent + '%');

        }, function() {


    });


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
                emails_sent_month.html(response.month_emails_sent);

                //Change Emails Opened Stats
                emails_opened_day.html(response.today_emails_opened);
                num_emails_opened_day.val(response.today_emails_opened);
                emails_opened_week.html(response.week_emails_opened);
                emails_opened_month.html(response.month_emails_opened);

                // Change Emails Clicked Stats
                emails_clicked_day.html(response.today_emails_clicked);
                emails_clicked_week.html(response.week_emails_clicked);
                emails_clicked_month.html(response.month_emails_clicked);


            }

        });



    }




});