class ResourceApi < Grape::API
  prefix 'api'
  format :json

  def initialize
    super
  end

  # Apps Resource API
  # -----------------
  resource :apps do
    # Get Routes
    # ----------------
    get do
      if params[:name]
        App.where(name: params[:name])
      elsif
        App.find(params[:id])
      else
        error!('Resource not found', 404)
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
      if params[:identifier]
        puts "Looking for hook with identifier"
        Hook.where(identifier: params[:identifier])
      elsif params[:id]
        puts "Looking for hook with id"
        Hook.find(params[:id])
      elsif params[:app_id]
        puts "Looking for hook with app_id"
        Hook.where(app_id: params[:app_id])
      else
        Hook.all
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


      # if params[:id]
      #   Funnel.find(params[:id])
      # elsif params[:app_id]
      #   Funnel.where(app_id: params[:app_id])
      # else
      #   error!('Resource not found', 404)
      # end
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

      # if params[:id]
      #   Trigger.find(params[:id])
      # elsif params[:app_id]
      #   Trigger.where(app_id: params[:app_id])
      # else
      #   error!('Resource not found', 404)
      # end
    end


    # Post/Put Routes
    # ----------------

    # creates new Trigger
    # POST /triggers
    post do
      Trigger.create! params
    end

    put ':id' do
      Trigger.find(params[:id]).save params
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
      # if params[:id]
      #   Link.find(params[:id])
      # elsif params[:app_id]
      #   Link.where(app_id: params[:app_id])
      # elsif params[:funnel_id]
      #   Link.where(funnel_id: params[:funnel_id])
      # else
      #   error!('Resource not found', 404)
      # end
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
      if params[:id]
        Node.find(params[:id])
      elsif params[:app_id]
        Node.where(app_id: params[:app_id])
      elsif params[:funnel_id]
        Node.where(funnel_id: params[:funnel_id])
      else
        error!('Resource not found', 404)
      end
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
      if params[:id]
        EmailList.find(params[:id])
      elsif params[:app_id]
        EmailList.where(app_id: params[:app_id])
      else
        error!('Resource not found', 404)
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
      if params[:id]
        EmailTemplate.find(params[:id])
      elsif params[:app_id]
        EmailTemplate.where(app_id: params[:app_id])
      else
        error!('Resource not found', 404)
      end
    end

    route_param :template_id do
      get do
        EmailTemplate.find(params[:template_id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailTemplate.create! params
    end

    put ':id' do
      EmailTemplate.find(params[:id]).save params
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
      if params[:id]
        CapturedHook.find(params[:id])
      elsif params[:app_id]
        CapturedHook.where(app_id: params[:app_id])
      else
        error!('Resource not found', 404)
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
      if params[:id]
        Subscriber.find(params[:id])
      elsif params[:app_id]
        Subscriber.where(app_id: params[:app_id])
      elsif params[:email_list_id]
        Subscriber.where(email_list_id: params[:email_list_id])
      else
        error!('Resource not found', 404)
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
      if params[:id]
        EmailListSubscriber.find(params[:id])
      elsif params[:app_id]
        EmailListSubscriber.where(app_id: params[:app_id])
      elsif params[:email_list_id]
        EmailListSubscriber.where(email_list_id: params[:email_list_id])
      elsif params[:subscriber_id]
        EmailListSubscriber.where(subscriber_id: params[:subscriber_id])
      else
        error!('Resource not found', 404)
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

end