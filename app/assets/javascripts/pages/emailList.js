$(function(){

    $("body").tooltip({ selector: '[data-toggle=tooltip]' });


    /* --- APP VALUES --- */
    var app_id = $('#current_app_id').val();


    /* --- AUTHENTICATION --- */
    var csrf_token = $('meta[name=csrf-token]').attr('content');

    /* --- MODALS --- */
    var new_email_list_modal = $('#new_email_list_modal');

    /* --- INPUT FIELDS --- */
    var listNameInput = $('#email_list_name_input');
    var listDescriptionInput = $('#email_list_description_input');

    /* --- BUTTONS --- */
    var emailListSubmit = $('#new_email_list_submit_button');

    /* --- HIDDEN VALUES --- */
    var default_emails_sent = $('#default_emails_sent').val();
    var default_emails_opened = $('#default_emails_opened').val();
    var default_emails_clicked = $('#default_emails_clicked').val();

    /* --- EMAIL STATS --- */
    var default_emails_opened_view = $('#default_emails_opened_view');
    var default_emails_clicked_view = $('#default_emails_clicked_view');


    //Initialize the page
    init();


    default_emails_opened_view.hover(function() {

        var percent = ((default_emails_opened / default_emails_sent) * 100).toFixed(2) + '%';

        default_emails_opened_view.html(percent);

    }, function() {

        default_emails_opened_view.html(default_emails_opened);

    });

    default_emails_clicked_view.hover(function() {

        var percent = ((default_emails_clicked / default_emails_sent) * 100).toFixed(2) + '%';

        default_emails_clicked_view.html(percent);

    }, function() {

        default_emails_clicked_view.html(default_emails_clicked);

    });


    $('.opened_hover').hover(function() {

        var id = $(this).data('id');
        var opened = $(this).data('opened');

        var sent = $('#list_sent_' + id).val();

        if (sent === '0') {
            $(this).html('0.00%');
        } else {
            var percent = ((opened / sent) * 100).toFixed(2) + '%';

            $(this).html(percent);
        }

    }, function() {

        $(this).html($(this).data('opened'));


    });


    $('.clicked_hover').hover(function() {

        var id = $(this).data('id');
        var clicked = $(this).data('clicked');

        var sent = $('#list_sent_' + id).val();

        if (sent === '0') {
            $(this).html('0.00%');
        } else {
            var percent = ((clicked / sent) * 100).toFixed(2) + '%';

            $(this).html(percent);
        }

    }, function() {

        $(this).html($(this).data('clicked'));

    });


    emailListSubmit.on("click", function(e) {

        e.preventDefault();

        var listName = listNameInput.val();
        var description = listDescriptionInput.val();


        $.ajax({
            type:'POST',
            url: '/ajax_create_email_list',
            dataType: "json",
            data: {
                app_id: app_id,
                name: listName,
                description: description,
                authenticity_token: csrf_token
            },
            error: function(e) {
                console.log(e);
            },
            success: function(response) {
                console.log(response);
                window.location.reload(true);
                new_email_list_modal.modal('toggle');
            }
        });

    });


    function init() {

        //Set the initial default list stats
        default_emails_opened_view.html(default_emails_opened);
        default_emails_clicked_view.html(default_emails_clicked);

    }




});