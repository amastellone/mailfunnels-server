class TriggerSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :esubject, :econtent, :ntriggered, :nesent, :delayt, :email_list_id, :hook_id, :app_id
end
