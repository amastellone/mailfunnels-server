class MailFunnelsUser


  # MAILFUNNELS USER UTIL FUNCTION
  # ------------------------------
  # Updates the users info from infusionsoft
  # Used to make sure that user is up to date
  # with infusionsoft and to update the users tags
  #
  # PARAMETERS
  # ----------
  # client_id: ID of the Infusionsoft Contact
  #
  # Returns: BOOLEAN (true/false) whether users info was updated
  #
  def self.update_user_info(client_id)

    # Get user from DB
    user = User.where(clientid: client_id).first

    # If User not found, return false
    unless user
      return false
    end

    # Start Update User Tags
    begin
      contact = Infusionsoft.data_load('Contact', user.clientid, [:FirstName, :LastName, :Email, :Website, :StreetAddress1, :City, :State, :PostalCode, :Groups])

      # Update User Info
      user.put('', {
          :first_name => contact['FirstName'],
          :last_name => contact['LastName'],
          :street_address => contact['StreetAddress1'],
          :city => contact['City'],
          :state => contact['State'],
          :zip => contact['PostalCode'],
          :client_tags => contact['Groups'],
      })

    rescue => e
      # Return false upon error
      return false
    end

    # User Updated Successfully, Return true
    return true

  end


  # MAILFUNNELS USER UTIL FUNCTION
  # ------------------------------
  # Updates the Users info and returns the current users plan
  #
  #
  # PARAMETERS
  # ----------
  # client_id: ID of the Infusionsoft Contact
  #
  # Returns: INTEGER
  # ----------------
  # -1 : Error
  # -2 : MailFunnels Free Trial User
  # -99 : Mailfunnels Free Trial Ended and No Plan (Account Disabled)
  # 106 : MailFunnels 1k
  # 108 : MailFunnels 2k
  # 110 : MailFunnels 4k
  # 112 : MailFunnels 8k
  # 114 : MailFunnels 12k
  # 116 : MailFunnels 20k
  # 118 : MailFunnels 35k
  # 120 : MailFunnels Failed Payment
  # 153 : Mailfunnels 60 day trial member
  # 171 : Mailfunnels Cancellation Request
  #
  def self.get_user_plan(client_id)

    # Update the User info
    status = self.update_user_info(client_id)

    # If Update user failed, return -1
    if status === false
      return -1
    end

    # Get the Updated User from DB
    user = User.where(clientid: client_id).first

    # If no user found, return -1
    unless user
      return -1
    end

    # Parse through Tags and set current plan
    current_plan = -1
    trial_user = false
    trial_ended = false
    sixty_day_trial = false
    tags = user.client_tags.split(",")
    tags.each do |tag|

      # Convert tag to integer
      temp = tag.to_i

      # If cancellation tag, return cancellation tag
      if temp === 171
        return 171
      end

      # If 60 day trial tag found
      if temp === 153
        sixty_day_trial = true
      end

      # If contact has failed payment tag, return 120
      if temp === 120
        return 120
      end

      # If tag is 139 (Free Trial Member)
      if temp === 139
        trial_user = true
      end

      if temp === 145
        puts " "
        puts "======================="
        puts "TRIAL ENDED == TRUE!!!"
        puts "======================="
        puts " "
        trial_ended = true
      end

      # If tag is a subscription tag, update current_plan
      if temp > 104 and temp < 120

        # If temp is greater than current_plan
        if temp > current_plan
          current_plan = temp
        end

      end

    end


    # If current plan is -1
    if current_plan === -1

      if trial_ended
        puts " "
        puts "======================="
        puts "returning 99"
        puts "======================="
        puts " "


        return -99

      elsif sixty_day_trial
        return 153

      elsif trial_user
        return -2
      end

    else
      puts " "
      puts "======================="
      puts "returning current plan 1"
      puts current_plan
      puts "======================="
      puts " "

      return current_plan

    end

    puts " "
    puts "======================="
    puts "returning current plan 2"
    puts current_plan
    puts "======================="
    puts " "
    return current_plan

  end


  # MAILFUNNELS USER UTIL FUNCTION
  # ------------------------------
  # Returns the number of subscribers left in subscription
  #
  # PARAMETERS
  # ----------
  # client_id: ID of the Infusionsoft Contact
  #
  # Returns: INTEGER number of subscribers left, -1 if error, -2 if no plan
  #
  def self.get_remaining_subs(client_id)

    # Get the current plan for user
    plan = self.get_user_plan(client_id)

    # If failed, return -1
    if plan === -1
      return -1
    end

    # Get User from DB
    user = User.where(clientid: client_id).first

    # If user not found, return -1
    unless user
      return -1
    end

    # Get App for User
    app = App.where(user_id: user.id).first

    # If no app found, return -1
    unless app
      return -1
    end

    # Get Number of Subscribers in app
    num_subscribers = app.subscribers.size



    case plan
      when 106
        return 1000 - num_subscribers
      when 108
        return 2000 - num_subscribers
      when 110
        return 4000 - num_subscribers
      when 112
        return 8000 - num_subscribers
      when 114
        return 12000 - num_subscribers
      when 116
        return 20000 - num_subscribers
      when 118
        return 35000 - num_subscribers
      when -2
        return 500 - num_subscribers
      when 153
        return 4000 - num_subscribers
      when -99
        return 0
      else
        return -2
    end

  end


  def self.process_account_cancellation(client_id)


    # Get user from DB
    user = User.where(clientid: client_id).first

    # If no user found, return -1 for erorr
    unless user
      return -1
    end

    # Verify that user has account cancellation tag
    user_plan = self.get_user_plan(client_id)

    # If user doesn't have cancellation tag, return -1 for error
    if user_plan != 171
      return -1
    end

    # Get all the tags for the user
    tags = user.client_tags.split(",")

    #Itterate through each tag
    tags.each do |tag|

      # Convert tag to integer
      temp = tag.to_i

      # If tag is a subscription tag
      if (temp < 120 && temp > 103) || temp === 153

        # Remove Subscription Tag From User
        Infusionsoft.contact_remove_from_group(client_id, temp)

      end

    end



    # Find recurring order for the user
    recurring_orders = Infusionsoft.data_query('RecurringOrderWithContact', 100, 0, {:ContactId => client_id}, [:Id, :ContactId])
    recurring = recurring_orders.select {|recurring| recurring['ContactId'] == client_id}[0]

    # If there is a recurring order, cancel it
    if recurring
      order = recurring['Id']

      # Remove the Users Subscription
      Infusionsoft.invoice_delete_subscription(order)
    end


    user_plan = self.get_user_plan(client_id)


    # Return 1 for success
    return 1

  end





end