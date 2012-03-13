ApplicationController.class_eval do

	around_filter :catch_not_found

	unless ActionController::Base.consider_all_requests_local
	    rescue_from Exception, :with => :render_error
	    rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found
	    rescue_from ActionController::RoutingError, :with => :render_not_found
	    rescue_from ActionController::UnknownController, :with => :render_not_found
	    rescue_from ActionController::UnknownAction, :with => :render_not_found
	 end 

	private

	def render_not_found(exception)
		logger.error
		render :template => "/error/404.html.erb", :status => 404
	end

	def render_error(exception)
		logger.error
		render :template => "/error/500.html.erb", :status => 500
	end

	def catch_not_found
		yield
	rescue ActiveRecord::RecordNotFound
		render :template => "/error/404.html.erb", :status => 404
	end

end