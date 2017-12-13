class TemplateController < ApplicationController


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

end
