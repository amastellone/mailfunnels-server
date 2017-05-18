class FunnelsController < ShopifyApp::AuthenticatedController
  before_action :set_funnel, only: [:show, :edit, :update, :destroy]


  # Page Render Function
  # --------------------
  # Renders the "Funnels" Page which lists out all
  # the funnels for the current app instance
  #
  def index
    @funnels = Funnel.all
  end

  def edit_funnel

  end

  # GET /funnels/1
  # GET /funnels/1.json
  def show
  end

  # GET /funnels/new
  def new
    @funnel = Funnel.new
  end

  # GET /funnels/1/edit
  def edit
  end

  # POST /funnels
  # POST /funnels.json
  def create
    @funnel = Funnel.new(funnel_params)

    respond_to do |format|
      if @funnel.save
        format.html { redirect_to @funnel, notice: 'Funnel was successfully created.' }
        format.json { render :show, status: :created, location: @funnel }
      else
        format.html { render :new }
        format.json { render json: @funnel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /funnels/1
  # PATCH/PUT /funnels/1.json
  def update
    respond_to do |format|
      if @funnel.update(funnel_params)
        format.html { redirect_to @funnel, notice: 'Funnel was successfully updated.' }
        format.json { render :show, status: :ok, location: @funnel }
      else
        format.html { render :edit }
        format.json { render json: @funnel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /funnels/1
  # DELETE /funnels/1.json
  def destroy
    @funnel.destroy
    respond_to do |format|
      format.html { redirect_to funnels_url, notice: 'Funnel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # USED WITH AJAX
  # Creates a new Funnel Model
  #
  # PARAMETERS
  # ----------
  # name: Name of the Funnel
  # description: description of the funnel
  #
  def ajax_create_funnel

    # Create new Funnel Model
    funnel = Funnel.new

    # Update the Fields of Funnel Model
    funnel.name = params[:name]
    funnel.description = params[:description]
    funnel.numTriggers = 0
    funnel.numRevenue = 0

    # Save Funnel to DB
    saveResponse = funnel.save!

    # Check to see if the job was saved and return correct JSON response
    if saveResponse
      final_json = JSON.pretty_generate(result = {
          'status' => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          'status' => false
      })
    end

    # Return JSON response
    render json: final_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funnel
      @funnel = Funnel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funnel_params
      params.require(:funnel).permit(:name, :description, :numTriggers, :numRevenue)
    end
end
