class EventsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create_attendance, :show]

  before_filter :authenticate_venue!, :only => [:new, :create]
  before_filter :authenticate_venue_or_admin!, :only => [:edit, :update, :destroy]


  layout 'application'

  # GET /events
  # GET /events.xml
  def index
    @events = Event.upcoming # default to all upcoming events

    if params.slice(:from, :to).present?
      from = params[:from].try(:split, '/') # month / day / year
      to   = params[:to].try(:split, '/') # month / day / year

      if from.present? and to.present?
        return redirect_to events_between_dates_url(from[2], from[0], from[1], to[2], to[0], to[1], params.slice(*search_params))
      elsif from.present?
        return redirect_to events_for_day_url(from[2], from[0], from[1])
      elsif to.present?
        return redirect_to events_for_day_url(to[2], to[0], to[1])
      end

    elsif params.slice(:year, :month, :day).present?
      from = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i).beginning_of_day
      to   = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i).end_of_day

      @date   = from
      @events = Event.between(from, to)

    elsif params.slice(:from_year, :from_month, :from_day, :to_year, :to_month, :to_day).present?
      @from = Time.zone.local(params[:from_year].to_i, params[:from_month].to_i, params[:from_day].to_i).beginning_of_day
      @to   = Time.zone.local(params[:to_year].to_i,   params[:to_month].to_i,   params[:to_day].to_i).end_of_day
      @events = Event.between(@from, @to)
    end

    @events = @events.with_cost(params[:cost]) if params[:cost].present?
    @events = @events.scoped_by_category(params[:category]) if params[:category].present?
    if params[:date].present?
      date = params[:date].split('-')
      from = Time.local(date[2], date[0], date[1]).beginning_of_day
      to   = Time.local(date[2], date[0], date[1]).end_of_day
      @events = @events.between(from, to)
    end
    
    @events = @events.includes({:venue => :location}, :location)
    
    if current_city
      @events = @events.for_city(current_city)
    end
    
    # Note: We do this in Ruby (not ActiveRecord) because of time-zone 
    # issues. See Event.filter_from_local_time for details.
    if params[:time_from].present?
      @events = Event.filter_from_local_time(@events, params[:time_from])
    end
    if params[:time_to].present?
      @events = Event.filter_to_local_time(@events, params[:time_to])
    end
    
    # Note: This is an array when filtered by time, and an AR object when 
    # not filtered by time.
    @events = @events.paginate(:per_page => params[:per_page] || Event.per_page, :page => params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  # GET /events/1.ics
  def show
    @event = Event.find(params[:id], :include => {:venue => :location})
    @event.record_view(request.env['REMOTE_ADDR'], request.env['HTTP_REFERER']) unless (venue_signed_in? and current_venue == @event.venue)

    respond_to do |format|
      format.html { render 'show' }
      format.xml  { render :xml => @event }
      format.ics  { render :inline => '<%= render_ics(@event) %>' }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = current_venue.events.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # POST /events
  # POST /events.xml
  def create
    @event = current_venue.events.build(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event was successfully created.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])

    if admin_or_owning_venue?
      @event.deleted = true
      @event.save!

      respond_to do |format|
        format.html { redirect_to(venue_events_url, :notice => 'The event was successfully deleted.') }
        format.xml  { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to(:back, :alert => 'You do not have permission to delete that event.') }
        format.xml  { head :permission_denied }
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to root_url 
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
    unless admin_or_owning_venue?
      return redirect_to(:back, :alert => 'You do not have permission to edit that event.')
    end
  rescue ActionController::RedirectBackError
    redirect_to root_url
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    if admin_or_owning_venue?
      respond_to do |format|
        if @event.update_attributes(params[:event])
          format.html { redirect_to(@event, :notice => 'Event was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to(:back, :alert => 'You do not have permission to edit that event.') }
        format.xml  { head :permission_denied }
      end
    end
  rescue ActionController::RedirectBackError
    redirect_to root_url 
  end

  def create_attendance
    @event = Event.find(params[:id])
    case params[:attending].to_s.downcase
    when 'yes'   then @event.increment!(:attending)
    when 'maybe' then @event.increment!(:maybe_attending)
    end
    respond_to do |format|
      format.js  { render }
    end
  end

  private
  
  helper_method :search_params
  def search_params
    [:category, :cost, :time_from, :time_to, :date, :per_page]
  end

  def admin_or_owning_venue?
    @event.venue == current_venue
  end

end
