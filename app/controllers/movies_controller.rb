class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @all_ratings = Movie.all_ratings
    
    @ratings_to_show = ratings_to_show

    @movies = with_ratings(@ratings_to_show).order(@sort)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def with_ratings(movie_ratings)
    Movie.where(rating: movie_ratings)
  end
  
#   # REFERENCE
#   def ratings_to_show
#     puts params[:ratings]
#     params[:ratings].nil? ? checked = @all_ratings : checked = params[:ratings].keys
#   end
  
  
  def ratings_to_show
    # Use remembered session rating or use params rating and update session rating
    # On page load
    if params[:ratings].nil?
      # Check for history
      if session[:ratings].nil?
        # Populate all to view all
        @showing_ratings = @all_ratings
      else 
        # Set from session
        @showing_ratings = session[:ratings]
      end
      
    else
      # Refresh (blue button): modifies url
      # Submit refresh: modifies url 
        @showing_ratings = params[:ratings].keys
        
    end
    # Save selected ratings to session
    session[:ratings] = @showing_ratings
    @showing_ratings
  end
  
  
  
  def sort_to_show
    # Use remembered session sort or use params sort and update session rating
    #params[:sort].nil? ? sort=nil : sort = params[:sort]
    #byebug
    if params[:sort].nil?
      @showing_sort = session[:sort]
    else
      
      @showing_sort = params[:sort]
       
    end
    session[:sort] = @showing_sort
    @showing_sort
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
