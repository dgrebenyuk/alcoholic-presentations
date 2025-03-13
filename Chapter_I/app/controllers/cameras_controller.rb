class CamerasController < ApplicationController
  before_action :set_camera, only: %i[ show edit update destroy ]
  skip_forgery_protection

  # GET /cameras or /cameras.json
  def index
    @cameras = Camera.all
  end

  # GET /cameras/1 or /cameras/1.json
  def show
  end

  # GET /cameras/new
  def new
    @camera = Camera.new
  end

  # GET /cameras/1/edit
  def edit
  end

  # POST /cameras or /cameras.json
  def create
    @camera = Camera.new(camera_params)

    respond_to do |format|
      if @camera.save
        format.html { redirect_to camera_url(@camera), notice: "Camera was successfully created." }
        format.json { render :show, status: :created, location: @camera }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cameras/1 or /cameras/1.json
  def update
    respond_to do |format|
      if @camera.update(camera_params)
        format.html { redirect_to devices_path, notice: "Camera was successfully updated." }
        format.json { render :show, status: :ok, location: @camera }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @camera.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cameras/1 or /cameras/1.json
  def destroy
    @camera.destroy

    respond_to do |format|
      format.html { redirect_to devices_path, notice: "Camera was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_camera
      @camera = Camera.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def camera_params
      params.require(:camera).permit(:name, :username, :password, :status)
    end
end
