class OrdersController < ApplicationController
  # GET /orders.json
  def index
    @orders = Order.all :include => :line_items

    respond_to do |format|
      format.json { render json: @orders.to_json(
          :include => {
              :line_items => {
                  :include => {
                      :product => {}
                  }
              }
          },
          :methods => [:net_total, :gross_total]
      ) }
    end
  end

  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.json { render json: @order.to_json(
          :include => {
              :line_items => {
                  :include => {
                      :product => {}
                  }
              }
          },
          :methods => [:net_total, :gross_total]
      ) }
    end
  end

  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.json { render json: @order.to_json(
          :include => {
              :line_items => {
                  :include => {
                      :product => {}
                  }
              }
          },
          :methods => [:net_total, :gross_total]
      ) }
    end
  end

  # POST /orders.json
  def create
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.json { render json: @order.to_json(
            :include => {
                :line_items => {
                    :include => {
                        :product => {}
                    }
                }
            },
            :methods => [:net_total, :gross_total]
        ), status: :created, location: @order }
      else
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.json { head :no_content }
      else
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
end
