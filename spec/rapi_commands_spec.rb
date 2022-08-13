require 'spec_helper'

describe Maxipago::Client do
  let(:headers) {
    {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'text/xml', 'User-Agent'=>'Ruby'}
  }

  context "Transaction Commands" do
    let(:setup) {
      {
        maxid: "100",
        apikey: "21g8u6gh6szw1gywfs165vui",
      }
    }

    let(:rapi) { Maxipago::RequestBuilder::RapiRequest.new(setup[:maxid], setup[:apikey])}

    before(:each) do
      @mp = Maxipago::Client.new
    end

    it "#one_transaction_report" do
      body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rapi-response><header><errorCode>0</errorCode><errorMsg/><command>transactionDetailReport</command><time>06-02-2013 14:43:06</time></header><result><resultSetInfo><totalNumberOfRecords>1</totalNumberOfRecords><pageNumber>1</pageNumber></resultSetInfo><records><record><transactionId>530368</transactionId><referenceNumber><![CDATA[21313]]></referenceNumber><transactionType>Boleto Payment</transactionType><transactionAmount>10.00</transactionAmount><taxAmount>0.00</taxAmount><shippingAmount>0.00</shippingAmount><transactionDate>06/02/2013 02:34:08 PM</transactionDate><orderId><![CDATA[10000001]]></orderId><userId/><customerId/><companyName/><responseCode>0</responseCode><approvalCode/><paymentType/><bankRoutingNumber/><achAccountNumber/><avsResponseCode/><billingName><![CDATA[Foo Bar]]></billingName><billingAddress1><![CDATA[Rua Foo Bar]]></billingAddress1><billingAddress2><![CDATA[Complemento Bar]]></billingAddress2><billingCity>Rio de Janeiro</billingCity><billingState>RJ</billingState><billingCountry/><billingZip>11111111</billingZip><billingPhone>111111111</billingPhone><billingEmail><![CDATA[foo@bar.com]]></billingEmail><comments/><transactionStatus>Approved</transactionStatus><transactionState>22</transactionState><recurringPaymentFlag/><creditCardType/><boletoNumber>10000001</boletoNumber><expirationDate>2013-05-15</expirationDate><processorID>BOLETO BRADESCO</processorID><customerId/><dateOfPayment/><dateOfFunding/><bankOfPayment/><branchOfPayment/><paidAmount/><bankFee/><netAmount/><returnCode/><clearingCode/><customField1/><customField2/><customField3/><customField4/><customField5/></record></records></result></rapi-response>"
      
      stub_request(:post, Maxipago::RequestBuilder::RapiRequest::URL).
        with(headers: headers).
        to_return(status: 200, body: body, headers: {})

      @mp.use(rapi)
      @mp.execute({ command: "one_transaction_report",
                    transaction_id: "530368" })
      expect(@mp.response[:body]).to eq(body)
    end

    it "#list_transactions_report" do
      body = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><rapi-response><header><errorCode>0</errorCode><errorMsg/><command>transactionDetailReport</command><time>06-02-2013 14:51:08</time></header><result><resultSetInfo><totalNumberOfRecords>25</totalNumberOfRecords><pageToken>temp1370209868399.1</pageToken><pageNumber>1</pageNumber><numberOfPages>25</numberOfPages></resultSetInfo><records><record><transactionId>530368</transactionId><referenceNumber><![CDATA[21313]]></referenceNumber><transactionType>Boleto Payment</transactionType><transactionAmount>10.00</transactionAmount><taxAmount>0.00</taxAmount><shippingAmount>0.00</shippingAmount><transactionDate>06/02/2013 02:34:08 PM</transactionDate><orderId><![CDATA[10000001]]></orderId><userId/><customerId/><companyName/><responseCode>0</responseCode><approvalCode/><paymentType/><bankRoutingNumber/><achAccountNumber/><avsResponseCode/><billingName><![CDATA[Foo Bar]]></billingName><billingAddress1><![CDATA[Rua Foo Bar]]></billingAddress1><billingAddress2><![CDATA[Complemento Bar]]></billingAddress2><billingCity>Rio de Janeiro</billingCity><billingState>RJ</billingState><billingCountry/><billingZip>11111111</billingZip><billingPhone>111111111</billingPhone><billingEmail><![CDATA[foo@bar.com]]></billingEmail><comments/><transactionStatus>Approved</transactionStatus><transactionState>22</transactionState><recurringPaymentFlag/><creditCardType/><boletoNumber>10000001</boletoNumber><expirationDate>2013-05-15</expirationDate><processorID>BOLETO BRADESCO</processorID><customerId/><dateOfPayment/><dateOfFunding/><bankOfPayment/><branchOfPayment/><paidAmount/><bankFee/><netAmount/><returnCode/><clearingCode/><customField1/><customField2/><customField3/><customField4/><customField5/></record></records></result></rapi-response>"
      
      stub_request(:post, Maxipago::RequestBuilder::RapiRequest::URL).
        with(headers: headers).
        to_return(status: 200, body: body, headers: {})

      @mp.use(rapi)
      @mp.execute({ command: "list_transactions_report",
                    period: "today",
                    pagesize: "1" })
      expect(@mp.response[:body]).to eq(body)
    end
  end
end
