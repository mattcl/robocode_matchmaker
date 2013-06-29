class ZipController < ApplicationController

  before_filter :authenticate_user!

  def starter_package
    respond_to do |format|
      format.zip { send_data current_user.get_custom_zipfile }
    end
  end
end
