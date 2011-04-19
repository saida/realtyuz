class ArticlesController < ApplicationController
  layout :set_layout
  
  def set_layout
    params[:layout] || 'admin'
  end
  
  skip_before_filter :login_required
  # GET /articles
  # GET /articles.xml
  def index
    @articles = Article.all(:include => [:account, :art_category])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
      format.json { render :json => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = Article.find(params[:id])
    @layout = params[:layout]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = Article.new
    @article.account_id = current_account.id
    list

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
    @layout = params[:layout]
    list
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    @article.account_id = current_account.id
    list

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :layout => params[:layout], :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = Article.find(params[:id])
    list

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :layout => params[:layout], :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
  def list
    @categories = ArtCategory.all.collect {|c| [c.name, c.id] }
  end
end
