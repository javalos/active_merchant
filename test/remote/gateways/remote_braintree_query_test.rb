require 'test_helper'

class RemoteBraintreeQueryTest < Test::Unit::TestCase
  def setup
    @gateway = BraintreeQueryGateway.new(fixtures(:braintree))
  end
  
  def test_successful_customer_vault_query
    assert response = @gateway.customer_vault('1234567890')
    assert_equal 'SUCCESS', response.message
    assert_success response
  end

  def test_invalid_login
    gateway = BraintreeQueryGateway.new(
                :login => '',
                :password => ''
              )
    assert response = gateway.customer_vault('1234567890')
    puts response.message
    assert_not_nil  response.message
    assert_failure response
  end
end
