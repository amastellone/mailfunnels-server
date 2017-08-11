class ChangeBroadcastListCascade < ActiveRecord::Migration[5.0]
  def up
    connection.execute(%q{
    alter table broadcast_lists
    drop constraint fk_broadcast_lists_email_list_id
  })
    connection.execute(%q{
    alter table broadcast_lists
    add constraint fk_broadcast_lists_email_list_id
    foreign key (email_list_id)
    references email_lists(id)
    on delete cascade
  })
  end
end
