module RunsHelper

  #Check if run exists
  def authenticate_run
    @run = Run.find_by(id: params[:id])
    redirect_unauthorized if @run.nil?
  end

  #Check if run belongs to current user
  def authenticate_correct_user
    redirect_unauthorized unless current_user.id == @run.user_id
  end

end
