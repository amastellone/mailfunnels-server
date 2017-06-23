class AddKeyToFunnels < ActiveRecord::Migration[5.0]
  def up
    connection.execute(%q{
    alter table funnels
    drop constraint fk_funnels_trigger_id
  })
    connection.execute(%q{
    alter table funnels
    add constraint fk_funnels_trigger_id
    foreign key (trigger_id)
    references triggers(id)
    on delete cascade
  })
  end

end
