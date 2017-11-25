/**
 * jQuery Handler for the Admin Dashboard
 */


/* --- GLOABL VARIABLES DECLARATION --- */
var csrf_token;
var app_id;


$(function() {

    /* --- AUTHENTICATION --- */
    csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- APP VALUES --- */
    app_id = $('#current_app_id').val();


    /* --- DASHBOARD STATS COMPONENTS --- */
    var num_active_apps = $('#mf_num_active_apps');
    var num_apps = $('#mf_num_apps');
    var num_captured_hooks = $('#mf_num_captured_hooks');
    var num_disabled_apps = $('#mf_num_disabled_apps');
    var num_email_clicked = $('#mf_num_email_clicked');
    var num_email_opened = $('#mf_num_email_opened');
    var num_email_sent = $('#mf_num_email_sent');
    var num_funnels = $('#mf_num_funnels');
    var num_subs = $('#mf_num_subs');
    var num_unsubs = $('#mf_num_unsubs');
    var num_users = $('#mf_num_users');
    var num_revenue = $('#mf_num_revenue');


    //Initialize the Admin Panel Page
    init();



    function init() {

        $.ajax({
            type: 'POST',
            url: 'https://mailfunnels-server.herokuapp.com/admin_dashboard_stats',
            data: {

            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                num_active_apps.html(response.num_active_apps);
                num_apps.html(response.num_apps);
                num_captured_hooks.html(response.num_captured_hooks);
                num_disabled_apps.html(response.num_disabled_apps);
                num_email_clicked.html(response.num_email_clicked);
                num_email_opened.html(response.num_email_opened);
                num_email_sent.html(response.num_email_sent);
                num_funnels.html(response.num_funnels);
                num_subs.html(response.num_subs);
                num_unsubs.html(response.num_unsubs);
                num_users.html(response.num_users);
                num_revenue.html(response.total_revenue.toFixed(2));
            }
        });

    }



});
