require "erb"
require 'premailer'

class TemplateController < ShopifyApp::AuthenticatedController

  # PAGE RENDER FUNCTION
  # --------------------
  # Renders the template builder page
  #
  # ROUTE: /template_builder/{template_id}
  #
  # Parameters
  # ----------
  # template_id : ID of the EmailTemplate we are editing
  #
  #
  def template_builder

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current user
    @user = User.find(@app.user_id)

    # Get the EmailTemplate We want to View
    @template = EmailTemplate.find(params[:template_id])

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
  def view_template

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current user
    @user = User.find(@app.user_id)

    # Get the EmailTemplate We want to View
    @template = EmailTemplate.find(params[:template_id])

  end




  # USED WITH AJAX
  # Updates a EmailTemplate Instance
  #
  # PARAMETERS
  # ------------
  #
  def ajax_save_email_template

    # Access current template being edited
    template = EmailTemplate.find(params[:id])

    template.html = params[:html]
    template.style_type = 1
    template.is_dynamic = params[:dynamic]
    template.has_ac_holder = params[:has_ac_holder]

    template.put('', {
        :html => template.html,
        :style_type => template.style_type,
        :is_dynamic => template.is_dynamic,
        :has_ac_holder => template.has_ac_holder
    })


    response = {
        :success => true
    }

    # Return JSON response
    render json: response


  end

  # USED WITH AJAX
  # Updates a EmailTemplate Instance
  #
  # PARAMETERS
  # ------------
  #
  def ajax_set_default_template

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Access current template being edited
    template = EmailTemplate.find(params[:id])

    template.html = params[:html]
    template.style_type = 1

    template.put('', {
        :html => template.html,
        :style_type => template.style_type
    })

    @app.put('', {
        :default_template => params[:html],
        :has_def_template => 1
    })


    response = {
        :success => true
    }

    # Return JSON response
    render json: response


  end

  # USED WITH AJAX
  # ---------------
  # Clones an EmailTemplate Instance
  #
  # PARAMETERS
  # ------------
  # template_id: ID of Email Template
  #
  def ajax_clone_template

    # Access current template being edited
    template = EmailTemplate.find(params[:template_id])

    template_clone = EmailTemplate.new
    template_clone.name = params[:name]
    template_clone.description = params[:description]
    template_clone.email_subject = params[:email_subject]
    template_clone.app_id = template.app_id
    template_clone.color = template.color
    template_clone.html = template.html
    template_clone.style_type = template.style_type
    template_clone.email_title = template.email_title
    template_clone.email_content = template.email_content
    template_clone.has_button = template.has_button
    template_clone.has_checkout_url = template.has_checkout_url
    template_clone.button_text = template.button_text
    template_clone.button_url = template.button_url
    template_clone.greet_use_default = template.greet_use_default
    template_clone.greet_content = template.greet_content
    template_clone.greet_before_cust_name = template.greet_before_cust_name
    template_clone.greet_after_cust_name = template.greet_after_cust_name

    # Save and verify Template and return correct JSON response
    template_clone.save!

    response = {
        :success => true
    }

    # Return JSON response
    render json: response

  end

  # USED WITH AJAX
  # Updates a EmailTemplate Instance
  #
  # PARAMETERS
  # ------------
  #
  def ajax_update_template_info

    # Access current template being edited
    template = EmailTemplate.find(params[:template_id])

    template.name = params[:name]
    template.description = params[:description]
    template.email_subject = params[:email_subject]

    template.put('', {
        :name => template.name,
        :description => template.description,
        :email_subject => template.email_subject
    })


    response = {
        :success => true
    }

    # Return JSON response
    render json: response


  end


  # USED WITH AJAX
  # --------------
  # Renders and sends test email of template
  #
  # ROUTE: /ajax/template/send_test_email
  #
  # PARAMETERS
  # --------------
  # email_template_id: ID of Email Template
  # to_email: Email to Send Test Email
  #
  def ajax_send_test_email

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get Template From DB
    @template = EmailTemplate.find(params[:email_template_id])

    unless @template
      response = {
          success: false,
          message: "ERROR: Template Not Found with ID Provided"
      }

      render json: response and return
    end

    if @app.from_name.nil?
      name = "Shop Admin"
    else
      name = @app.from_name
    end

    if @app.from_email.nil?
      email = "noreply@custprotection.com"
    else
      email = @app.from_email
    end

    if @template.style_type === 1
      html = File.open("app/views/template/styles/mf-minimal_1.html.erb").read
    else
      html = File.open("app/views/email/template.html.erb").read
    end

    product = ShopifyAPI::Product.find(288398540810)

    puts product.to_s

    @email_content = RedCloth.new(Liquid::Template.parse(@template.html).render(
        'product_title' => product.title,
        'product_description' => product.body_html,
        'product_image' => product.images[0].src
    )).to_html

    @renderedhtml = "1"
    ERB.new(html, 0, "", "@renderedhtml").result(binding)


    ERB.new(@renderedhtml, 0, "", "@renderedhtml").result(binding)


    if @template.style_type === 1
      premailer = Premailer.new(@renderedhtml, { :warn_level => Premailer::Warnings::SAFE, :with_html_string => true})

      @renderedhtml = premailer.to_inline_css

    end

    # Send Email Using Postmark
    client = Postmark::ApiClient.new('b650bfe2-d2c6-4714-aa2d-e148e1313e37', http_open_timeout: 60)
    response = client.deliver(
        :subject => "MailFunnels Email Preview",
        :to => params[:to_email],
        :from => name+' '+email,
        :html_body => @renderedhtml,
        :track_opens => 'true')

    render json: response

  end



  # AJAX ROUTE
  # ----------
  # Uploads an image to AWS
  #
  # PARAMS
  # ------
  # :file (Image File .jpg to upload to server)
  def upload_image_to_aws

    puts "HERE"

    file_name = params[:file]

    puts file_name.tempfile

    key = SecureRandom.hex + ".jpg"

    obj = S3_BUCKET.object(key)
    obj.upload_file(file_name.tempfile)


    response = {
        success: true,
        url: 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/' + key
    }

    render json: response

  end


  def mf_email_template_add_link

    url = "http://#{params[:url]}" unless params[:url]=~/^https?:\/\//

    # Create a new TemplateHyperlink Instance
    hyperlink = TemplateHyperlink.new

    # Update the attributes of the TemplateHyperlink
    hyperlink.app_id = MailfunnelsUtil.get_app.id
    hyperlink.email_template_id = params[:template_id]
    hyperlink.site_url = url

    hyperlink.save!

    response = {
        success: true,
        link: url
    }

    # Return JSON response
    render json: response
  end

end
