class RunsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit]
  before_action :authenticate_run, only: [:update, :edit]
  before_action :authenticate_correct_user, only: [:update, :edit]


  def index
    @runs = current_user&.runs
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new run_params
    @run.user_id = current_user.id
    if @run.save
      flash.now[:success] = 'Run successfuly created'
      redirect_to runs_path
    else
      flash.now[:danger] = 'Creating run failed, please correct mistakes'
      render 'new'
    end
  end

  def update
    if @run.update_attributes run_params
      flash.now[:success] = 'Run successfuly updated'
      redirect_to runs_path
    else
      flash.now[:danger] = 'Updating run failed, please correct mistakes'
      render 'edit'
    end
  end

  def edit
  end


  private

  #Check if run exists
  def authenticate_run
    @run = Run.find_by(id: params[:id])
    redirect_unauthorized if @run.nil?
  end

  #Check if run belongs to current user
  def authenticate_correct_user
    redirect_unauthorized unless current_user? @run.user_id
  end

  #Allowed parameter for Run model
  def run_params
    params.require(:run).permit(:distance, :duration, :date)
  end

end
