class MoviesController < ApplicationController

  @@SORT_BY = [:title, :release_date] 
  

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id)
    # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    @movies = Movie.all
    
    @movies = Movie.order(params[:sort])
    
  
    if not params.key?(:commit) and not params.key?(:sort_by) and not params.key?(:ratings) and session[:movies_query]
      saved=session[:movies_query]
      flash.keep
      session.delete :movies_query
      redirect_to movies_path(saved)
    else
      session[:movies_query] = request.query_parameters
    end
    
    if params.include? :sort_by
      @sort_by = params[:sort_by]

      if @@SORT_BY.include? @sort_by.to_sym
        @movies = @movies.order @sort_by
        eval("@hilite_#{@sort_by} = 'hilite'")
        flash.delete :notice
      else
        flash[:notice] = "Cannnot sort by selected parameter \"#{@sort_by}\"." 
      end
    else
      @sort_by = false
    end
    
    
    
    if params.include? :ratings
      @ratings_to_show = params[:ratings].keys
      @movies = @movies.where(:rating => @ratings_to_show)
    else
      @ratings_to_show = []
      @movies = []
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
 
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
