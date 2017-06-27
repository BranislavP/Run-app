module ApplicationHelper
  def redirect_unauthorized
    flash[:danger] = 'Not authorized'
    redirect_to root_path
  end

  def form_errors_for(object=nil)
    render('shared/form_errors', object: object) unless object.blank? or object.errors.count == 0
  end

end
