class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorized_user, except: [:set_primary, :create, :update, :destroy]

  # GET /addresses
  # GET /addresses.json
  def index
    @addresses = Address.all
  end

  # GET /addresses/1
  # GET /addresses/1.json
  def show
  end

  # GET /addresses/new
  def new
    @address = Address.new
  end

  # GET /addresses/1/edit
  def edit
  end

  def set_primary
    primaddress = Address.find(params[:address_id])
    addresses = Address.where(user_id: current_user.id)

    addresses.each do |address|
      if address == primaddress
        address.update_attribute(:is_primary, true)
      else
        address.update_attribute(:is_primary, false)
      end
    end

    redirect_to user_address_path
  end

  # POST /addresses
  # POST /addresses.json
  def create
    @address = Address.new(address_params)
    @address.user = current_user

    respond_to do |format|
      if @address.save
        format.html { redirect_to @address, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /addresses/1
  # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to @address, notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /addresses/1
  # DELETE /addresses/1.json
  def destroy
    @address.destroy

    addresses = Address.where(user_id: current_user.id)
    primupdated = false

    addresses.each do |address|
      if !primupdated 
        address.update_attribute(:is_primary, true)
        primupdated = true
      else
        address.update_attribute(:is_primary, false)
      end
    end

    respond_to do |format|
      format.html { redirect_to user_address_path, notice: 'Address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
      params.require(:address).permit(:full_address, :apartment, :city, :state, :postal_code, :is_primary, :address_id, :longitude, :latitude)
    end

    def authorized_user
      if user_signed_in?
        if current_user.role != :admin
          raise ActionController::RoutingError.new('Not Found')
        end
      else
        raise ActionController::RoutingError.new('Not Found')
      end
    end
end
