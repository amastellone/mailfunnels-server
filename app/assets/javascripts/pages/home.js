$(function(){

    /* --- Date Values --- */
    var date = new Date();
    var current_date = date.getDate();
    var day_date = current_date + 1;
    var week_date = current_date + 7;
    var month_date = current_date + 30;

    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();

    /* --- View Dashboard Info Components --- */
    var new_subscribers_day = ('#new_subscribers_day');
    var emails_sent_day = ('#emails_sent_day');
    var emails_opened_day = ('#emails_opened_day');
    var emails_clicked_day = ('#emails_clicked_day');

    var new_subscribers_week = ('#new_subscribers_week');
    var emails_sent_week = ('#emails_sent_week');
    var emails_opened_week = ('#emails_opened_week');
    var emails_clicked_week = ('#emails_clicked_week');

    var new_subscribers_month = ('#new_subscribers_month');
    var emails_sent_month = ('#emails_sent_month');
    var emails_opened_month = ('#emails_opened_month');
    var emails_clicked_month = ('#emails_clicked_month');



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
            new_subscribers_day.html(response.todaysSubscribers);
            new_subscribers_week.html(response.weeksSubscribers);
            new_subscribers_month.html(response.monthSubscribers);






            console.log(response);

        }









    });









});