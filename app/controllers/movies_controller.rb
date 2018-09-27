class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  
  def index
    @path = "movies_path"
    @all_ratings=Movie.select(:rating).map(&:rating).uniq
    @rating_boxes=params[:ratings]
    
    #update sort if params has changed. Keep with session otherwise.
    if params[:sort]
      @sort=params[:sort]
      session[:sort]=params[:sort]
    else
      @sort=session[:sort]
    end

    #if conditions for ratings
    if @rating_boxes
      @movies=Movie.where(:rating => @rating_boxes.keys)
      session[:ratings]=@rating_boxes
    elsif session[:ratings]
      @movies=Movie.where(:rating => session[:ratings].keys)
    end 
      
    #if conditions for sort
    if @sort == 'title'
      @movies=Movie.order(title: :ASC).where(:rating=> session[:ratings].keys)
    elsif @sort == 'release_date' 
      @movies=Movie.order(release_date: :ASC).where(:rating=> session[:ratings].keys)
    else
      @movies=Movie.all
    end
    
  

    
    
    
    
  end

  def new
    # default: render 'new' template
  end

  def sort(param)
    if param==3
     print("Success")
    end 
    #  @movie=Movie.sort(@movie.title) #correct this syntax
   # @sort=print("Hello from controller")
    
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


end
