# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170520190138) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name",       :index=>{:name=>"index_apps_on_name", :unique=>true, :using=>:btree}
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.string   "auth_token", :index=>{:name=>"index_apps_on_auth_token", :unique=>true, :using=>:btree}
  end

  create_table "email_lists", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.integer  "app_id",      :foreign_key=>{:references=>"apps", :name=>"fk_email_lists_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__email_lists_app_id", :using=>:btree}
  end

  create_table "hooks", force: :cascade do |t|
    t.text     "name"
    t.text     "identifier"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end


  create_table "emails", force: :cascade do |t|
    t.string   "email_address"
    t.string   "name"
    t.datetime "created_at",    :null=>false
    t.datetime "updated_at",    :null=>false
    t.integer  "app_id",        :foreign_key=>{:references=>"apps", :name=>"fk_emails_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__emails_app_id", :using=>:btree}
    t.integer  "email_list_id", :foreign_key=>{:references=>"email_lists", :name=>"fk_emails_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__emails_email_list_id", :using=>:btree}
  end

  create_table "campaign_product_leads", force: :cascade do |t|
    t.integer  "app_id",             :foreign_key=>{:references=>"apps", :name=>"fk_campaign_product_leads_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_app_id", :using=>:btree}
    t.integer  "product_identifier"
    t.integer  "campaign_id",        :foreign_key=>{:references=>"campaigns", :name=>"fk_campaign_product_leads_campaign_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_campaign_id", :using=>:btree}
    t.integer  "job_id",             :foreign_key=>{:references=>"jobs", :name=>"fk_campaign_product_leads_job_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_job_id", :using=>:btree}
    t.boolean  "sold",               :default=>false
    t.decimal  "sale_ammount",       :default=>"0.0"
    t.integer  "email_list_id",      :foreign_key=>{:references=>"email_lists", :name=>"fk_campaign_product_leads_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_email_list_id", :using=>:btree}
    t.integer  "email_id",           :foreign_key=>{:references=>"emails", :name=>"fk_campaign_product_leads_email_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__campaign_product_leads_email_id", :using=>:btree}
    t.datetime "BuyDate"
    t.datetime "ClickDate"
    t.string   "Source"
  end

  create_table "funnels", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "numTriggers"
    t.float    "numRevenue"
    t.datetime "created_at",  :null=>false
    t.datetime "updated_at",  :null=>false
    t.integer  "app_id",      :foreign_key=>{:references=>"apps", :name=>"fk_funnels_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__funnels_app_id", :using=>:btree}
  end

  create_table "mail_funnel_server_configs", force: :cascade do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
  end

  create_table "triggers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "esubject"
    t.string   "econtent"
    t.integer  "ntriggered"
    t.integer  "nesent"
    t.integer  "delayt"
    t.datetime "created_at",          :null=>false
    t.datetime "updated_at",          :null=>false
    t.integer  "email_list_id",       :foreign_key=>{:references=>"email_lists", :name=>"fk_triggers_email_list_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__triggers_email_list_id", :using=>:btree}
    t.integer  "hook_id",             :foreign_key=>{:references=>"hooks", :name=>"fk_triggers_hook_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__triggers_hook_id", :using=>:btree}
    t.integer  "app_id",              :foreign_key=>{:references=>"apps", :name=>"fk_triggers_app_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__triggers_app_id", :using=>:btree}
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "name"
    t.integer  "top"
    t.integer  "left"
    t.integer  "hits"
    t.integer  "uhits"
    t.integer  "nemails"
    t.integer  "nesent"
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.integer  "funnel_id",  :foreign_key=>{:references=>"funnels", :name=>"fk_nodes_funnel_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__nodes_funnel_id", :using=>:btree}
    t.integer  "trigger_id", :foreign_key=>{:references=>"triggers", :name=>"fk_nodes_trigger_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__nodes_trigger_id", :using=>:btree}
  end

  create_table "links", force: :cascade do |t|
    t.datetime "created_at", :null=>false
    t.datetime "updated_at", :null=>false
    t.integer  "slink"
    t.integer  "funnel_id",  :foreign_key=>{:references=>"funnels", :name=>"fk_links_funnel_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__links_funnel_id", :using=>:btree}
    t.integer  "fni", :foreign_key=>{:references=>"nodes", :name=>"fk_links_from_node_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__links_from_node_id", :using=>:btree}
    t.integer  "tni", :foreign_key=>{:references=>"nodes", :name=>"fk_links_to_node_id", :on_update=>:no_action, :on_delete=>:no_action}, :index=>{:name=>"fk__links_to_node_id", :using=>:btree}
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", :null=>false, :index=>{:name=>"index_shops_on_shopify_domain", :unique=>true, :using=>:btree}
    t.string   "shopify_token",  :null=>false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
