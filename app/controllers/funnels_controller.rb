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


    # Save and verify Funnel and return correct JSON response
    if funnel.save!
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


    # Save and verify Node and return correct JSON response
    if node.save!
      final_json = JSON.pretty_generate(result = {
          :success => true,
          :id => node.id
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
  # --------------
  # Adds a new link to the funnel being edited
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the funnel the link is being added on
  # from_operator_id: Operator we are starting link from
  # to_operator_id: Operator we are ending the link on
  #
  def ajax_add_link

    # Create a new Link Instance
    link = Link.new

    # Update the fields of Link Instance
    link.funnel_id = params[:funnel_id]
    link.tni = params[:to_operator_id].to_i

    if params[:from_operator_id].to_i === 0
      # If the link starts at the start node, set slink to 1
      link.slink = 1
    else
      # Otherwise, set slink to 0 (false) and set from_operator_id
      link.slink = 0
      link.fni = params[:from_operator_id].to_i
    end

    # Save and verify Link and return correct JSON response
    if link.save!
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
  # --------------
  # Loads a JSON representation of nodes on funnel builder
  # to be loaded ino flowchart plugin
  #
  # PARAMETERS
  # ----------
  # funnel_id: ID of the Funnel to get nodes for
  #
  def ajax_load_funnel_json

    # Load all the Nodes and Links for the current Funnel
    @nodes = Node.where(funnel_id: params[:funnel_id])
    @links = Link.where(funnel_id: params[:funnel_id])

    # Create a new array to hold the operators
    operators = Hash.new

    # Create start operator
    operators[0] =
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

    # For every Node we have in the DB, create an operator with its fields
    @nodes.each do |node|

      operators[node.id] =
          {
              :top => node.attributes['attributes'].top,
              :left => node.attributes['attributes'].left,
              :properties => {
                  :title => node.attributes['attributes'].name,
                  class:'flowchart-operator-email-node',
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

    # Create a new links array
    links = Hash.new

    # For every Link for the funnel, create a flowchart link with its fields
    @links.each do |link|

      if link.attributes['attributes'].slink === 1
        fromNode = 0
      else
        fromNode = link.attributes['attributes'].fni
      end

      links[link.id] =
          {
              :fromConnector => 'output_1',
              :toConnector => 'input_1',
              :fromOperator => fromNode,
              :toOperator => link.attributes['attributes'].tni,
          }
    end



    # Create data JSON with operators and links
    data = JSON.pretty_generate({
                                    'operators' => operators,
                                    'links' => links
                                })


    # Return JSON array with flowchart data
    render json: data

  end


  # USED WITH AJAX
  # --------------
  # Updates the node on the funnel when moved
  #
  # PARAMETERS
  # ----------
  # node_id: ID of the node that was updated
  # top: Distance from top in pixels
  # left: Distance from left in pixels
  #
  def ajax_save_node

    # Get the Node from the DB
    node = Node.where(id: params[:node_id]).first

    # Update the Node
    node.top = params[:top]
    node.left = params[:left]

    # Save and verify Node and return correct JSON response
    if node.save!
      final_json = JSON.pretty_generate(result = {
          :success => true,
          :id => node.id
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
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
      params.require(:funnel).permit(:name, :description, :numTriggers, :numRevenue, :app_id)
    end
end
