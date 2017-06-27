class RunsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit]
  before_action :authenticate_run, only: [:update, :edit]
  before_action :authenticate_correct_user, only: [:update, :edit]


  def index
    @runs = Run.where(user_id: current_user&.id).order(date: :desc)
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
  #Allowed parameter for Run model
  def run_params
    params.require(:run).permit(:distance, :duration, :date)
  end

end
