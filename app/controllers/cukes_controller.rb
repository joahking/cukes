class CukesController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :text => "ajaxed cukes" }
    end
  end
end
