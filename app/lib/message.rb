class Message
  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.unauthorized
    'Unauthorized request'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.account_not_created
    'Account could not be created'
  end

  def self.login_success
    'Login was successful'
  end
  
  def self.account_exists
    'Account already exists'
  end

  def self.record_not_found
    "Resource not found"
  end

  def self.create_success(record = 'record')
    "#{record} was created successfully"
  end

  def self.update_success(record = 'record')
    "#{record} was updated successfully"
  end

  def self.delete_success(record = 'record')
    "#{record} was deleted successfully"
  end

  def self.car_unavailable
    'Sorry, this car is no longer available'
  end

  def self.order_unavailable
    'Sorry, this order has been marked as accepted or rejected'
  end
end
