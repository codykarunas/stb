class EmployeeCartsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_cart
  # before_action :authenticate_user!
  before_action :set_employee_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @employee_carts = EmployeeCart.all
    @employee_cart = EmployeeCart.find_by(params[:id])
    @items = Item.all
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
    @items = Item.all
  end

  # GET /carts/new
  def new
    @employee_cart = EmployeeCart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @employee_cart = Cart.new(employee_cart_params)

    respond_to do |format|
      if @employee_cart.save
        # format.html { redirect_to root_path, notice: 'Cart was successfully created.' }
        format.html { redirect_to @employee_cart, notice: 'Employee Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @employee_cart.update(employee_cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @employee_cart.destroy if @cart.id == session[:employee_cart_id]
    session[:empoyee_cart_id] = nil
    respond_to do |format|
      # format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.html { redirect_to items_path, notice: 'Employee Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee_cart
    @employee_cart = EmployeeCart.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_cart_params
    params.fetch(:employee_cart, {})
  end

  def invalid_cart
    logger.error "Attempt to access invalid cart #{params[:id]}"
    redirect_to root_path, notice: "That cart doesn't exist"
  end
end
