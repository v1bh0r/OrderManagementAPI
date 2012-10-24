class ProductsController < ApplicationController
  # GET /products.json
  def index
    @products = Product.all

    respond_to do |format|
      format.json { render json: @products }
    end
  end

  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.json { render json: @product }
    end
  end

  # GET /products/new.json
  def new
    @product = Product.new

    respond_to do |format|
      format.json { render json: @product }
    end
  end

  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.json { render json: @product, status: :created, location: @product }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.json { head :no_content }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
