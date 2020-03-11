class JobsApplicationsController < ApplicationController
  before_action :set_jobs_application, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorized_user, except: [:create, :update, :new, :destroy]
  invisible_captcha only: [:update]

  # GET /jobs_applications
  # GET /jobs_applications.json
  def index
    @jobs_applications = JobsApplication.all
  end

  # GET /jobs_applications/1
  # GET /jobs_applications/1.json
  def show
  end

  # GET /jobs_applications/new
  def new
    @jobs_application = JobsApplication.new
    @jobs_application.address = Address.new
    @address = active_address

    if params.has_key?(:jobtype)
      if params[:jobtype] == "appdev"
        @jobtype = "Smartphone App Developer"
      elsif params[:jobtype] == "convstaff"
        @jobtype = "Convenience Store Staff"
      elsif params[:jobtype] == "bedmaking"
        @jobtype = "Hotel Bed Making"
      else
        @jobtype = ""
      end
    else
      @jobtype = ""
    end
  end

  # GET /jobs_applications/1/edit
  def edit
  end

  # POST /jobs_applications
  # POST /jobs_applications.json
  def create
    @jobs_application = JobsApplication.new(jobs_application_params)
    @jobs_application.user = current_user

    user_addresses = Address.where(:full_address => @jobs_application.address.full_address)
    if user_addresses.present?
      user_addresses.first.destroy
    end

    respond_to do |format|
      if @jobs_application.save        
        set_address_primary(@jobs_application.address)

        NewsletterMailer.new_job_application(current_user.id.to_s, @jobs_application.id.to_s).deliver_later(wait: 1.second)
        NewsletterMailer.new_job_application_company(current_user.id.to_s, @jobs_application.id.to_s).deliver_later(wait: 1.second)
        format.html { redirect_to user_job_app_url + "#jobSuccess", notice: 'Jobs application was successfully created.' }
        format.json { render :show, status: :created, location: root_url }
      else
        format.html { render :new }
        format.json { render json: @jobs_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /jobs_applications/1
  # PATCH/PUT /jobs_applications/1.json
  def update
    respond_to do |format|
      if @jobs_application.update(jobs_application_params)
        set_address_primary(@jobs_application.address)

        NewsletterMailer.new_job_application(current_user.id.to_s, @jobs_application.id.to_s).deliver_later(wait: 1.second)
        NewsletterMailer.new_job_application_company(current_user.id.to_s, @jobs_application.id.to_s).deliver_later(wait: 1.second)
        format.html { redirect_to user_job_app_url + "#jobSuccess", notice: 'Jobs application was successfully updated.' }
        format.json { render :show, status: :ok, location: user_job_app_url }
      else
        format.html { render :edit }
        format.json { render json: @jobs_application.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs_applications/1
  # DELETE /jobs_applications/1.json
  def destroy
    @jobs_application.destroy
    respond_to do |format|
      format.html { redirect_to user_job_app_url, notice: 'Jobs application was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jobs_application
      @jobs_application = JobsApplication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jobs_application_params
      params.require(:jobs_application).permit(:name, :jobtype, :age, :nationality, :expiry, :addresslat, :addresslong, :phone, :email, 
        address_attributes: [:id, :full_address, :apartment, :city, :state, :postal_code, :user_id, :latitude, :longitude])
    end

    def active_address
      if user_signed_in?
        address = Address.where(:user_id => current_user.id, :is_primary => true)

        if address.present?
          address = address.first
        else
          address = Address.new
          address.user = current_user
        end
        return address
      end
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

    def set_address_primary(primary)
      if user_signed_in?
        user_addresses = Address.where(user: current_user)
        user_addresses.each do |address|
          if address == primary
            address.update_attribute :is_primary, true
          else
            address.update_attribute :is_primary, false
          end
        end
      end
    end
end
