# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :set_entry
  before_action :set_entry_item, only: [:show, :update, :destroy]

  # GET /entries/:entry_id/items
  def index
    json_response(@entry.items)
  end

  # GET /entries/:entry_id/items/:id
  def show
    json_response(@item)
  end

  # POST /entries/:entry_id/items
  def create
    @entry.items.create!(item_params)
    json_response(@entry, :created)
  end

  # PUT /entries/:entry_id/items/:id
  def update
    @item.update(item_params)
    head :no_content
  end

  # DELETE /entries/:entry_id/items/:id
  def destroy
    @item.destroy
    head :no_content
  end

  private

  def item_params
    params.permit(:name, :visible)
  end

  def set_entry
    @entry = Entry.find(params[:entry_id])
  end

  def set_entry_item
    @item = @entry.items.find_by!(id: params[:id]) if @entry
  end
end
