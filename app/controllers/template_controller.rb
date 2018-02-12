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
