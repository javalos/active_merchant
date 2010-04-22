require 'test_helper'

class BraintreeQueryTest < Test::Unit::TestCase
  
  def setup
    @gateway = BraintreeQueryGateway.new(
      :login => 'LOGIN',
      :password => 'PASSWORD'
    )
    @customer_vault_id = '8675309'
  end
  
  def test_successful_customer_vault_query
    @gateway.expects(:ssl_post).returns(successful_customer_query_response)
  
    assert response = @gateway.customer_vault(@customer_vault_id)
    assert_instance_of Response, response
    assert_success response
    params = response.params
    assert_equal 'Jack' , params['first_name']
    assert_equal 'Bauer' , params['last_name']
    assert_equal '123 Fake ST' , params['address_1']
    assert_equal 'Suite SWEET' , params['address_2']
    assert_equal 'My Comp' , params['company']
    assert_equal 'Chicago' , params['city']
    assert_equal 'IL' , params['state']
    assert_equal '60643' , params['postal_code']
    assert_equal 'US' , params['country']
    assert_equal 'me@myplace.com', params['email']
    assert_equal '312-865-5309' , params['phone']
    assert_equal '555-867-5309' , params['fax']
    assert_equal '773-867-5309' , params['cell_phone']
    assert_equal '111' , params['customertaxid']
    assert_equal 'http://xkcd.com' , params['website']
    assert_equal 'j' , params['shipping_first_name']
    assert_equal 'b' , params['shipping_last_name']
    assert_equal '345 Fake St.' , params['shipping_address_1']
    assert_equal 'Suite 4' , params['shipping_address_2']
    assert_equal 'Yo' , params['shipping_company']
    assert_equal 'Orlando' , params['shipping_city']
    assert_equal 'FL' , params['shipping_state']
    assert_equal '11111' , params['shipping_postal_code']
    assert_equal 'US' , params['shipping_country']
    assert_equal 'me@work.com' , params['shipping_email']
    assert_equal '4xxxxxxxxxxx1111' , params['cc_number']
    assert_equal '5a3ce15f56656efa406ec981602fd2e2' , params['cc_hash']
    assert_equal '1010' , params['cc_exp']
    assert_equal 'proca' , params['processor_id']
    assert_equal '411111' , params['cc_bin']
    assert_equal '123456' , params['customer_vault_id']
  end

  def test_failed_customer_vault_query
    @gateway.expects(:ssl_post).returns(error_customer_query_response)
  
    assert response = @gateway.customer_vault(@customer_vault_id)
    assert_instance_of Response, response
    assert_failure response
    
  end
  
  def test_no_results_customer_vault_query
    @gateway.expects(:ssl_post).returns(no_results_customer_query_response)
    
    assert response = @gateway.customer_vault(@customer_vault_id)
    assert_instance_of Response, response
    assert_success response
    params = response.params
    assert_nil params['customer_vault_id']
       
  end
  
  private 
    def successful_customer_query_response
      <<-RESPONSE
        <?xml version="1.0"?>
        <nm_response>
        <customer_vault>
        <customer id="123456" />
        <first_name>Jack</first_name>
        <last_name>Bauer</last_name>
        <address_1>123 Fake ST</address_1>
        <address_2>Suite SWEET</address_2>
        <company>My Comp</company>
        <city>Chicago</city>
        <state>IL</state>
        <postal_code>60643</postal_code>
        <country>US</country>
        <email>me@myplace.com</email>
        <phone>312-865-5309</phone>
        <fax>555-867-5309</fax>
        <cell_phone>773-867-5309</cell_phone>
        <customertaxid>111</customertaxid>
        <website>http://xkcd.com</website>
        <shipping_first_name>j</shipping_first_name>
        <shipping_last_name>b</shipping_last_name>
        <shipping_address_1>345 Fake St.</shipping_address_1>
        <shipping_address_2>Suite 4</shipping_address_2>
        <shipping_company>Yo</shipping_company>
        <shipping_city>Orlando</shipping_city>
        <shipping_state>FL</shipping_state>
        <shipping_postal_code>11111</shipping_postal_code>
        <shipping_country>US</shipping_country>
        <shipping_email>me@work.com</shipping_email>
        <cc_number>4xxxxxxxxxxx1111</cc_number>
        <cc_hash>5a3ce15f56656efa406ec981602fd2e2</cc_hash>
        <cc_exp>1010</cc_exp>
        <processor_id>proca</processor_id>
        <cc_bin>411111</cc_bin>
        <customer_vault_id>123456</customer_vault_id>
        </customer_vault>
        </nm_response>
      RESPONSE
    end
    
    def error_customer_query_response
      <<-RESPONSE
      <?xml version="1.0"?>
      <nm_response>
      <error_response>Invalid Username/Password</error_response>
      </nm_response>
      RESPONSE
    end
    
    def no_results_customer_query_response
      <<-RESPONSE
      <?xml version="1.0"?>
      <nm_response>
      </nm_response>
      RESPONSE
    end
end
