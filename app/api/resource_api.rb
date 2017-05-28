class ResourceApi < Grape::API
  prefix 'api'
  format :json

  def initialize
    super
  end


  get 'email_opened' do
    messageID = params[:messageID]

    emailJob = EmailJob.find(params[:postmark_id])

    node = emailJob.node

    node.clicked = 1
    node.save

  end

  # Apps Resource API
  # -----------------
  resource :apps do
    # Get Routes
    # ----------------
    get do
        App.where(params)
    end

    route_param :id do
      get do
        App.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      App.create! params
    end

    put ':id' do
      App.find(params[:id]).save params
    end

    put do
      App.save params
    end


  end

  # Hooks Resource API
  # ------------------
  resource :hooks do
    # Get Routes
    # ----------------

    get do
        Hook.where(params)
    end

    route_param :id do
      get do
        Hook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Hook.create! params
    end

    put ':id' do
      Hook.find(params[:id]).save params
    end

    put do
      Hook.save params
    end


  end


  # Funnels Resource API
  # --------------------
  resource :funnels do
    # Get Routes
    # ----------------
    get do
      Funnel.where(params)
    end


    # GET funnels/:funnel_id
    route_param :funnel_id do
      get do
        Funnel.find(params[:funnel_id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Funnel.create! params
    end

    put ':id' do
      Funnel.find(params[:id]).save params
    end

    put do
      Funnel.save params
    end


  end


  # Triggers Resource API
  # ---------------------
  resource :triggers do
    # Get Routes
    # ----------------

    get do
      Trigger.where(params)
    end

    route_param :id do
      get do
        Trigger.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------

    # creates new Trigger
    # POST /triggers
    post do
      Trigger.create! params
    end

    put ':id' do
      Trigger.find(params[:id]).update(params)
    end

    put do
      Trigger.save params
    end

  end

  # Links Resource API
  # ------------------
  resource :links do
    # Get Routes
    # ----------------

    get do
      Link.where(params)
    end

    route_param :id do
      get do
        Link.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Link.create! params
    end

    put ':id' do
      Link.find(params[:id]).save params
    end

    put do
      Link.save params
    end

  end


  # Nodes Resource API
  # ------------------
  resource :nodes do
    # Get Routes
    # ----------------

    get do
      Node.where(params)
    end

    route_param :id do
      get do
        Node.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Node.create! params
    end

    put ':id' do
      Node.find(params[:id]).update params
    end

    put do
      Node.save! params
    end

  end


  # EmailList Resource API
  # ----------------------
  resource :email_lists do
    # Get Routes
    # ----------------
    get do
        EmailList.where(params)
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailList.create! params
    end

    put ':id' do
      EmailList.find(params[:id]).save params
    end

    put do
      EmailList.save params
    end
  end

  # EmailTemplate Resource API
  # --------------------------
  resource :email_templates do
    # Get Routes
    # ----------------
    get do
      EmailTemplate.where(params)
    end

    route_param :id do
      get do
        EmailTemplate.find(params[:id])
      end
      put do
        EmailTemplate.find(params[:id]).update(params)
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailTemplate.create! params
    end

    put do
      EmailTemplate.save params
    end

  end

  # CapturedHooks Resource API
  # --------------------------
  resource :captured_hooks do
    # Get Routes
    # ----------------

    get do
        CapturedHook.where(params)
    end

    route_param :id do
      get do
        CapturedHook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      CapturedHook.create! params
    end

    put ':id' do
      CapturedHook.find(params[:id]).save params
    end

    put do
      CapturedHook.save params
    end


  end

  # Subscriber Resource API
  # ------------------------
  resource :subscribers do
    # Get Routes
    # ----------------
    get do
      Subscriber.where(params)
    end

    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end

    
    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Subscriber.create! params
    end

    put ':id' do
      Subscriber.find(params[:id]).save params
    end

    put do
      Subscriber.save params
    end
  end

  # EmailListSubscriber Resource API
  # ------------------------
  resource :email_list_subscribers do
    # Get Routes
    # ----------------
    get do
      EmailListSubscriber.where(params)
    end

    route_param :id do
      get do
        EmailListSubscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailListSubscriber.create! params
    end

    put ':id' do
      EmailListSubscriber.find(params[:id]).save params
    end

    put do
      EmailListSubscriber.save params
    end
  end

  # EmailJobResource API
  # ------------------------
  resource :email_jobs do
    # Get Routes
    # ----------------
    get do
      EmailJob.where(params)
    end

    route_param :id do
      get do
        EmailJob.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do

      emailJob = EmailJob.create({:app_id => params[:app_id],
                                 :funnel_id => params[:funnel_id],
                                 :subscriber_id => params[:subscriber_id],
                                 :executed => params[:executed],
                                 :node_id => params[:node_id],
                                 :email_template_id => params[:email_template_id],
                                 :sent => params[:sent]
                                 })
      node = Node.find(emailJob.node_id)

      SendEmailJob.set(wait: node.delay_time.seconds).perform_later(emailJob.id,params[:renderedEmail])
      puts "---Email Job Created---"
    end

    put ':id' do
      EmailJob.find(params[:id]).save params
    end

    put do
      EmailJob.save params
    end
  end


end