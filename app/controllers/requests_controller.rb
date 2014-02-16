class RequestsController < ApplicationController

  require 'twilio-ruby'


  def get_requests
    requests = Request.all
    render json: requests, status: 200, example_params: false
  end

  # This method captures the incoming sms message
  def request_incoming
    # And the message text
    from = params[:From]
    text = Request.store_sms(params[:Body], from)

    # Return the message back out
    render xml: text
  end


  def create_request
    request = Request.create
    if params[:post_code].present?
      coords = request.reverse_geolocation(params[:post_code])
    else
      coords = [params[:latitude], params[:longitude]]
    end
    request.update(telephone: params[:telephone])
    request.store_coords(coords[0], coords[1])
    request.store_status(params[:email][:status])
    redirect_to :back
  end
end
