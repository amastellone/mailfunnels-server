class NullKeyToEmailListSubscribers < ActiveRecord::Migration[5.0]

  def up
    connection.execute(%q{
    alter table email_list_subscribers
    drop constraint fk_email_list_subscribers_email_list_id
  })
    connection.execute(%q{
    alter table email_list_subscribers
    add constraint fk_email_list_subscribers_email_list_id
    foreign key (email_list_id)
    references email_lists(id)
    on delete set NULL
  })
  end

end
