class EmailController < ShopifyApp::AuthenticatedController
  before_action :set_list_id, only: [:emails]
  before_action :set_email_list, only: [:editlist, :updatelist, :destroylist]
  protect_from_forgery with: :null_session


  # Page Render Function
  # --------------------
  # Renders the Email Lists Page which displays
  # card view of all Email Lists
  #
  def lists

    @app  = MailfunnelsUtil.get_app
    @lists = EmailList.where(app_id: @app.id)

  end


  # Page Render Function
  # --------------------
  # Renders the All Email Templates Page
  # which displays card view of all the email
  # templates for the app
  #
  def email_templates

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all Email Templates For the App
    @templates = EmailTemplate.where(app_id: @app.id, is_archived: 0)

  end



  # Page Render Function
  # --------------------
  # Renders the view template page
  #
  #
  # PARAMETERS
  # ----------
  # template_id: ID of the EmailTemplate we are viewing
  #
  def view_email_template

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current user
    @user = User.find(@app.user_id)

    # Get the EmailTemplate We want to View
    @template = EmailTemplate.find(params[:template_id])

  end



  # Page Render Function
  # --------------------
  # Renders the edit template page
  #
  #
  # Parameters
  # ----------
  # template_id : ID of the EmailTemplate we are editing
  #

  def edit_email_template

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current user
    @user = User.find(@app.user_id)

    # Get the EmailTemplate We want to View
    @template = EmailTemplate.find(params[:template_id])

  end


  # USED WITH AJAX
  # Creates a new EmailTemplate Instance
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app being used
  # name: Name of the EmailTemplate
  # description: description of the EmailTemplate
  # email_subject: Email Subject of the EmailTemplate
  # email_content: Email Content of the EmailTemplate
  #
  def ajax_create_email_template

    app = MailfunnelsUtil.get_app

    # Create a new EmailTemplate Instance
    template = EmailTemplate.new

    # Update the attributes of the EmailTemplate
    template.app_id = params[:app_id]
    template.name = params[:name]
    template.description = params[:description]
    template.email_subject = params[:email_subject]
    template.color = app.email_def_color

    if params[:use_builder] === "1"
      template.style_type = 1
    else
      template.style_type = 0
    end

    if app.has_def_template == 1
      template.html = app.default_template
    else
      template.html = "<div class='row clearfix'><div class='column full'><h1 class='size-48 is-title1-48 is-title-bold is-upper' style='text-align: center;'>Lorem Ipsum Risus Pharetra</h1></div></div><div class='row clearfix'><div class='column full'><p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus leo ante, consectetur sit amet vulputate vel, dapibus sit amet lectus.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus leo ante, consectetur sit amet vulputate vel, dapibus sit amet lectus.&nbsp;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus leo ante, consectetur sit amet vulputate vel, dapibus sit amet lectus.&nbsp;</p></div></div><div class='row clearfix'><div class='column full center'><div style='margin:1em 0'><a href='#' class='btn btn-primary' style='border-radius: 50px; color: rgb(255, 255, 255); background-color: rgb(68, 152, 228);''>READ MORE</a></div></div></div>"
    end



    # Save and verify Funnel and return correct JSON response
    if template.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json
  end


  # USED WITH AJAX
  # Updates a EmailTemplate Instance
  #
  # PARAMETERS
  # ------------
  # email_subject: Subject/Title of email
  # email_content: Content/Body text of email
  # button: Button boolean to add button to email
  # button_text: Text displayed on button
  # button_url: URL that button is linked to
  #
  def ajax_update_email_template

    # Access current template being edited
    template = EmailTemplate.find(params[:id])

    template.name = template.name
    template.description = template.description
    template.app_id = template.app_id
    template.email_subject = params[:email_subject]
    template.email_title = params[:email_title]
    template.email_content = params[:email_content]
    template.has_button = params[:has_button]
    template.color = params[:color]
    template.has_checkout_url = params[:has_checkout]

    template.button_text = params[:button_text]
    template.button_url = params[:button_url]

    template.button_url = "http://#{params[:button_url]}" unless params[:button_url]=~/^https?:\/\//

    template.put('', {
        :email_subject => template.email_subject,
        :email_title => template.email_title,
        :email_content => template.email_content,
        :has_button => template.has_button,
        :button_text => template.button_text,
        :button_url => template.button_url,
        :color => template.color,
        :has_checkout_url => template.has_checkout_url,
        :greet_use_default => params[:greet_use_default],
        :greet_content => params[:greet_content],
        :greet_before_cust_name => params[:greet_before_cust_name],
        :greet_after_cust_name => params[:greet_after_cust_name]
    })


    final_json = JSON.pretty_generate(result = {
        :success => true
    })

    # Return JSON response
    render json: final_json


  end

  # USED WITH AJAX
  # Creates new EmailList
  #
  # PARAMETERS
  # -----------
  # app_id: ID of the current app being used
  # name: Name of the new EmailList
  # description: Description of the new EmailList
  #
  def ajax_create_email_list

    list = EmailList.new

    list.app_id = params[:app_id]
    list.name = params[:name]
    list.description = params[:description]
    list.active = 0

    # Save and verify Template and return correct JSON response
    if list.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  def ajax_delete_template

    # Get the funnel from the DB
    template = EmailTemplate.find(params[:template_id])

    if !template.nil?
      template.put('', {
          :is_archived => 1
      })
    end

    final_json = JSON.pretty_generate(result = {
        :success => true
    })

    # Return JSON response
    render json: final_json

  end



  # EMAIL TEMPLATE RENDER FUNCTION
  # ------------------------------
  # Renders the Email Template for the customer
  #
  def template
    puts "hit template route"
    @template = EmailTemplate.find(params[:id])

    render :template => "email/template"
  end

  def get_binding
    binding
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list_id
    @list = EmailList.find(params[:list_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_email_list
    @email_list = EmailList.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_list_params
    params.require(:email_list).permit(:email_subject,
                                       :email_content,
                                       :email_title,
                                       :has_button,
                                       :button_text,
                                       :button_url,
                                       :color,
                                       :app_id,
                                       :greet_use_default,
                                       :greet_before_cust_name,
                                       :greet_after_cust_name,
                                       :greet_content,
                                       :email_content,
                                       :has_button,
                                       :html)
  end
end
