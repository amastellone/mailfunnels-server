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
		@list = EmailList.where(app_id: @app.id)

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
    @templates = EmailTemplate.where(app_id: @app.id)
    
  end

	# POST /create_list
	def create_list

		logger.debug 'We made it to create_list'

		app = MailfunnelsUtil.get_app

		@email_list = EmailList.new(name: params[:name], description: params[:description], app_id: app.id)

		if @email_list.save
			@message = 'Email list was successfully created.'
		else
			@message = 'Email list was NOT created.'
		end

	end

	def emails

		@app    = MailfunnelsUtil.get_app
		@emails = Email.where(email_list_id: @list.id)


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
		params.require(:email_list).permit(:name, :description, :app_id)
	end
end
