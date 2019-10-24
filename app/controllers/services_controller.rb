class ServicesController < ApplicationController
  def index
    @services = Service.all

    render layout: 'blank'
  end
end
