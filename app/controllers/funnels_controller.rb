class FunnelsController < ShopifyApp::AuthenticatedController
  before_action :set_funnel, only: [:show, :edit, :update, :destroy]


  # Page Render Function
  # --------------------
  # Renders the "Funnels" Page which lists out all
  # the funnels for the current app instance
  #
  def index

    # Get the current app loaded
    @app_id = BluehelmetUtil.get_app.id

    # Get all Funnel models
    @funnels = Funnel.where(app_id: @app_id)

    logger.info @funnels
  end


  # Page Render Function
  # --------------------
  # Renders the "Edit Funnel" Page which allows user
  # to edit the funnel using drag and drop funnel builder
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel we are editing
  #
  def edit_funnel

    # Get the Current App ID
    @app_id = BluehelmetUtil.get_app.id

    # Find the funnel from the DB
    @funnel = Funnel.find(params[:funnel_id])

    @triggers = Trigger.where(app_id: @app_id)

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
  # app_id: ID of the current app being used
  # name: Name of the Funnel
  # description: description of the funnel
  #
  def ajax_create_funnel

    # Create new Funnel Model
    funnel = Funnel.new

    # Update the Fields of Funnel Model
    funnel.name = params[:name]
    funnel.description = params[:description]
    funnel.app_id = params[:app_id]
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

  # USED WITH AJAX
  # --------------
  # Adds a new node to the funnel being edited
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel the node is being added on
  # name: Name of the Node
  # trigger_id: ID of the trigger the node is related to
  #
  def ajax_add_node

    # Create a new Node Instance
    node = Node.new

    # Update the fields of Node Instance
    node.name = params[:name]
    node.funnel_id = params[:funnel_id]
    node.trigger_id = params[:trigger_id]
    node.top = 60
    node.left = 500
    node.hits = 0
    node.uhits = 0
    node.nemails = 0
    node.nesent = 0

    # Save Node to DB
    saveResponse = node.save!

    # Check to see if the node was saved and return correct JSON response
    if saveResponse
      final_json = JSON.pretty_generate(result = {
          'status' => true,
          'id' => node.id
      })
    else
      final_json = JSON.pretty_generate(result = {
          'status' => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  # USED WITH AJAX
  # --------------
  # Loads a JSON representation of nodes on funnel builder
  # to be loaded ino flowchart plugin
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the Funnel to get nodes for
  #
  def ajax_load_funnel_json

    @nodes = Node.where(funnel_id: params[:funnel_id])

    # Create a new array to hold the operators
    operators = Hash.new

    operators['startNode'] =
        {
            :top => 20,
            :left => 20,
            :properties => {
                :title => 'Start',
                class: 'flowchart-operator-start-node',
                inputs: {},
                outputs: {
                    output_1: {
                        label: ' ',
                    }
                }
            }
        }

    @nodes.each do |node|

      operators[node.id] =
          {
              :top => node.attributes['attributes'].top,
              :left => node.attributes['attributes'].left,
              :properties => {
                  :title => node.attributes['attributes'].name,
                  class: 'flowchart-operator-email-node',
                  :inputs => {
                      :input_1 => {
                          :label => ' '
                      }
                  },
                  :outputs => {
                      :output_1 => {
                          :label => ' '
                      }
                  }
              }
          }


    end

    links = Hash.new


    data = JSON.pretty_generate({
                                    'operators' => operators,
                                    'links' => links
                                })


    render json: data

  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funnel
      @funnel = Funnel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def funnel_params
      params.require(:funnel).permit(:name, :description, :numTriggers, :numRevenue, :app_id)
    end
end
