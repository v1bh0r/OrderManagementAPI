class LineItemsController < ApplicationController
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.json { render json: @line_item }
    end
  end

  # POST /line_items.json
  def create
    @line_item = LineItem.new(params[:line_item])

    respond_to do |format|
      if @line_item.save
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.json { head :no_content }
      else
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
