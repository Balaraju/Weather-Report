class ZipcodesController < ApplicationController
  def index
    @zipcode=Zipcode.new
  end

  def get_details_by_zip 
    #this is REST webservice using JSON
    request = HTTPI::Request.new("http://free.worldweatheronline.com/feed/weather.ashx?q=#{params[:code]}&format=json&num_of_days=5&key=099493171a111943132302")
    response=HTTPI.get(request)
    #above two lines for getting json to the given url
    raw_body=response.raw_body
    result=ActiveSupport::JSON.decode(raw_body)
    data=result["data"]
    current_condition=data.assoc("current_condition")
    @current_report=current_condition[1][0]
    conditions=data.assoc("weather")
    @day1_report=conditions[1][0]
    @day2_report=conditions[1][1]
    @day3_report=conditions[1][2]
    
  end
  
  def get_state_by_zip
    #this is SOAP webservice using on XML
    client = Savon.client(wsdl: "http://www.webservicex.net/uszip.asmx?WSDL")
    response = client.call :get_info_by_zip, message: { "USZip" => params[:code] }
    info=response.to_array(:get_info_by_zip_response, :get_info_by_zip_result, :new_data_set, :table).first
    @state = info[:state]
    @city = info[:city]
    @area_code = info[:area_code]
    @time_zone = info[:time_zone]
  end
end
