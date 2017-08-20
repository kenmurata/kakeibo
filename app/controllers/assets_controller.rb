class AssetsController < ApplicationController
  def index
    @assets = Asset.all
  end
  
  def new
  end
end
