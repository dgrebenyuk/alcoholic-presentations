class DevicesController < ApplicationController
  include ActionController::Live

  before_action :set_device, only: %i[ show edit update destroy ]

  # GET /devices or /devices.json
  def index
    @devices = Device.all.includes(:cameras).load_async
    @timelines = Timeline.all.load_async

    respond_to do |format|
      format.html
      format.csv do
        send_stream(filename: 'devices.csv') do |stream|
          stream.write "ip,vendor\n"
          @devices.find_in_batches(batch_size: 5) do |devices|
            devices.each do |device|
              stream.write "#{device.ip},#{device.vendor}\n"
            end
            sleep 0.5
          end
        end
      end
    end
  end

  # GET /devices/1 or /devices/1.json
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices or /devices.json
  def create
    @device = Device.new(device_params)

    respond_to do |format|
      if @device.save
        format.html { redirect_to device_url(@device), notice: "Device was successfully created." }
        format.json { render :show, status: :created, location: @device }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /devices/1 or /devices/1.json
  def update
    respond_to do |format|
      if @device.update(device_params)
        format.html { redirect_to device_url(@device), notice: "Device was successfully updated." }
        format.json { render :show, status: :ok, location: @device }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @device.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /devices/1 or /devices/1.json
  def destroy
    @device.destroy

    respond_to do |format|
      format.html { redirect_to devices_url, notice: "Device was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def device_params
      params.require(:device).permit(:ip, :netmask, :vendor, :channels, :description)
    end
end
