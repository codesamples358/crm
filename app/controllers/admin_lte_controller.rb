class AdminLteController < ApplicationController
  skip_before_action :authenticate_user!
  layout 'admin_lte'
end
