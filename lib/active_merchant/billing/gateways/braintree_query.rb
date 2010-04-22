module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BraintreeQueryGateway < Gateway
      def api_url 
        'https://secure.braintreepaymentgateway.com/api/query.php'
      end
    
      self.homepage_url = 'http://www.braintreepaymentsolutions.com'
      self.display_name = 'Braintree Query'
      
      def initialize(options = {})
        requires!(options, :login, :password)
        @options = options
        super
      end
      
      def customer_vault(customer_vault_id)
        post = {:customer_vault_id => customer_vault_id,
                :report_type => 'customer_vault'}
        commit(post)  
      end
      
      def commit(parameters)
        response = parse( ssl_post(api_url, post_data(parameters)) )
        Response.new(!response[:error_response], response[:error_response] || 'SUCCESS', response, 
          :test => test?
        )    
      end
      
      def post_data(parameters = {})
        post = {}
        post[:username]      = @options[:login]
        post[:password]   = @options[:password]

        request = post.merge(parameters).map {|key,value| "#{key}=#{CGI.escape(value.to_s)}"}.join("&")
        request        
      end
      
      def parse(xml)
        response = {}

        xml = REXML::Document.new(xml)          
        xml.elements.each('//nm_response/customer_vault/*') do |node|
          response[node.name.downcase.to_sym] = normalize(node.text)
        end unless xml.root.nil?
        xml.elements.each('//nm_response/error_response') do |node|
          response[node.name.downcase.to_sym] = normalize(node.text)
        end unless xml.root.nil?

        response
      end
      
      # Make a ruby type out of the response string
      def normalize(field)
        case field
        when "true"   then true
        when "false"  then false
        when ""       then nil
        when "null"   then nil
        else field
        end
      end
      
   end
  end
end