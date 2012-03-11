class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order_hilite = {}
    @all_ratings = Movie.valid_ratings
    ratings = params[:ratings]
    if ratings.nil? then
      ratings = session[:ratings]
      should_redirect = !ratings.nil?
    else
      session[:ratings] = ratings
    end
    order = params[:order]
    if order.nil? then
      order = session[:order]
      should_redirect = should_redirect or !order.nil?
    else
      session[:order] = order
    end
    if should_redirect then
      redirect_to movies_path({:order => order, :ratings => ratings})
    end

    if ratings then
      condition = ["rating in (?)", ratings.keys]
    end
    @movies = Movie.find(:all, :order => params[:order], :conditions => condition)
    if params[:order] then
      @order_hilite = {params[:order] => 'hilite'}
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
