require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe EventsController do
  render_views

  let(:mock_event){ Factory.create(:event) }

  describe "GET index" do
    let(:event_list){ [ mock_event ] }
    before{ event_list.stub(:includes).and_return(event_list) }

    it "assigns all upcoming events as @events" do
      Event.should_receive(:upcoming).and_return(event_list)
      get :index
      assigns(:events).should eq([mock_event])
    end
    
    #PT BUG #19189643
    # it "assigns all events when supplying empty date parameters" do
    #   Event.should_receive(:scoped).and_return(event_list)
    #   get :index, "from"=>"", "to"=>""
    #   assigns(:events).should eq([mock_event])
    # end
    # 
    # Justin requested different functionality, so that it only returns 
    # current events instead.
    # PT Feature #19615169
    it "assigns only upcoming events when supplying empty date parameters" do
      venue = Factory.create(:venue)
      event_in_past   = Factory.create(:event, :venue => venue, :start_at => 2.days.ago)
      event_in_future = Factory.create(:event, :venue => venue, :start_at => 2.days.from_now)
      
      get :index, "from"=>"", "to"=>""
      assigns(:events).should include event_in_future
      assigns(:events).should_not include event_in_past
    end
    
    it "shows only events for specific day when specified" do
      date = Date.today
      Event.should_receive(:between).with(date.beginning_of_day, date.end_of_day).and_return(event_list)
      get :index, :year => date.year, :month => date.month, :day => date.day
      assigns(:events).should eq([mock_event])
    end

    context "when current city is set" do
      before do 
        @city = Factory.create(:city)
        @request.session[:city_id] = @city.id
      end
      
      it "shows only events for that city" do
        Event.should_receive(:for_city).with(@city).and_return(event_list)
        get :index
        assigns(:events).should eq([mock_event])
      end
    end

    context "when string from and to provided" do
      it "redirects to date range paged" do
        get(:index, :from => '05/04/2011', :to => '05/10/2011').should redirect_to(
          events_between_dates_url('2011', '05', '04', '2011', '05', '10'))
      end

      it "redirects to date page if only from provided" do
        get(:index, :from => '05/04/2011').should redirect_to(
          events_for_day_url('2011', '05', '04'))
      end

      it "redirects to date page if only to provided" do
        get(:index, :to => '05/04/2011').should redirect_to(
          events_for_day_url('2011', '05', '04'))
      end

      it "passes along search params" do
        get(:index, :from => '05/04/2011', :to => '05/10/2011', :category => 'other').should redirect_to(
          events_between_dates_url('2011', '05', '04', '2011', '05', '10', :category => 'other'))
      end
    end

    it "shows only events between dates when specified" do
      from = Date.civil(2011, 5, 4)
      to   = Date.civil(2011, 5, 10)
      Event.should_receive(:between).with(from.beginning_of_day, to.end_of_day).and_return(event_list)
      get :index, :from_year => from.year, :from_month => from.month, :from_day => from.day,
                  :to_year   => to.year,   :to_month   => to.month,   :to_day   => to.day
      assigns(:events).should eq([mock_event])
    end

  end

  describe "GET show" do
    
    it "can render as ics" do
      get :show, :id => mock_event.id, :format => :ics
      response.should be_successful
    end
    
    it "assigns the requested event as @event" do
      get :show, :id => mock_event.id
      assigns(:event).should eq(mock_event)
    end

    context "view tracking" do
      it "should add a view of the event" do
        expect{ get :show, :id => mock_event.id }.to change{ View.count }.by(1)
      end

      it "should store IP in view" do
        get :show, :id => mock_event.id
        mock_event.views.last.ip_address.should eq(request.env['REMOTE_ADDR'])
      end

      it "should not add a view if creating venue is logged in" do
        venue = Factory.create(:venue)
        event = Factory.create(:event, :venue => venue)

        sign_in(venue)
        expect{ get :show, :id => event.id }.to_not change{ View.count }
      end
      
      it "should track HTTP_REFERER when present" do
        request.env['HTTP_REFERER'] = 'www.example.com'
        get :show, :id => mock_event.id
        mock_event.views.last.http_referer.should eq('www.example.com')
      end
    end
  end

  describe "PUT create_attendance" do
    it "assigns the requested event as @event" do
      put :create_attendance, :id => mock_event.id
      assigns(:event).should eq(mock_event)
    end

    it "increments the 'attending' count if 'addending' param  is 'yes'" do
      expect{
        put :create_attendance, :id => mock_event.id, :attending => 'yes'
        mock_event.reload }.to change{ mock_event.attending }.by(1)
    end

    it "increments the 'maybe_attending' count if 'addending' param  is 'maybe'" do
      expect{
        put :create_attendance, :id => mock_event.id, :attending => 'maybe'
        mock_event.reload }.to change{ mock_event.maybe_attending }.by(1)
    end
  end

  describe "routes requiring authorization" do
    context "when logged in as venue" do
      let(:venue){ Factory.create(:venue) }
      before{ sign_in venue }

      describe "GET new" do

        it "should render" do
          get :new
          response.should be_success
        end

        it "should assign a new event for logged-in venue as @event" do
          get :new
          assigns(:event).should be_new_record
          assigns(:event).venue.should eq(venue)
        end

      end # GET new

      describe "POST create" do
        context "with valid params" do
          let(:event_attrs){ Factory.attributes_for(:event) }

          it "should create an event and assign to @event" do
            post :create, :event => event_attrs

            event = assigns(:event)
            event.should_not be_nil
            event.should_not be_new_record
            event.name.should eq(event_attrs[:name])

            flash[:notice].should eq('Event was successfully created.')
          end

          it "should allow assigning a location" do
            location = Factory.create(:location)
            event_attrs.merge!(:location_id => location.id )
            post :create, :event => event_attrs
            assigns(:event).location.should eq(location)
          end

          it "should allow creating a new location" do
            location_attributes = Factory.attributes_for(:location)
            event_attrs.merge!(:location_attributes => location_attributes)
            post :create, :event => event_attrs
            assigns(:event).location.name.should eq(location_attributes[:name])
          end


        end # with valid params
      end # POST create

      describe "DELETE destroy" do
        context "when current venue owns event" do
          let(:event){ Factory.create(:event, :venue => venue) }
          it "sets the event to 'deleted'" do
            expect{ delete :destroy, :id => event.id
                    event.reload }.to change{ event.deleted }.from(false).to(true)
          end
      
          it "redirects to the events list" do
            delete :destroy, :id => event.id
            response.should redirect_to(venue_events_url)
          end
        end

        context "when the current venue doesn't own the event" do
          let(:other_venue){ Factory.create(:venue) }
          let(:event){ Factory.create(:event, :venue => other_venue) }
          before{ request.env["HTTP_REFERER"] = 'example.com' }

          it "should not delete the event" do
            expect{ delete :destroy, :id => event.id }.to_not change{ event.deleted }.from(false)
          end

          it "should display an error message" do
            delete :destroy, :id => event.id
            flash[:alert].should eq('You do not have permission to delete that event.')
          end

        end

      end # DELETE destroy

      describe "GET edit" do
        context "when current venue owns event" do
          let(:event){ Factory.create(:event, :venue => venue) }
          it "assigns the requested event as @event" do
            get :edit, :id => event.id
            assigns(:event).should eq(event)
          end
        end # context when current venue owns event

        context "when the current venue doesn't own the event" do
          let(:other_venue){ Factory.create(:venue) }
          let(:event){ Factory.create(:event, :venue => other_venue) }
          before{ request.env["HTTP_REFERER"] = 'example.com' }

          it "should display an error message" do
            get :edit, :id => event.id
            flash[:alert].should eq('You do not have permission to edit that event.')
          end
        end # context when current venue doesn't own the event
      end # GET edit

      describe "PUT update" do
        context "when current venue owns the event" do
          let(:event){ Factory.create(:event, :venue => venue) }
          describe "with valid params" do
            it "updates the requested event" do
              put :update, :id => event.id, :event => {:name => 'New Event Name'}
              assigns(:event).name.should eq('New Event Name')
            end

            it "assigns the requested event as @event" do
              put :update, :id => event.id, :event => {:name => 'New Event Name'}
              assigns(:event).should eq(event.reload)
            end

            it "redirects to the event" do
              put :update, :id => event.id, :event => {:name => 'New Event Name'}
              event.reload
              response.should redirect_to(event_url(event))
            end
          end

          describe "with invalid params" do
            it "assigns the event as @event" do
              put :update, :id => event.id, :event => { :name => '' }
              assigns(:event).should eq(event)
            end

            it "re-renders the 'edit' template" do
              put :update, :id => event.id, :event => { :name => '' }
              response.should render_template("edit")
            end
          end
        end # context when current venue owns event

        context "when the current venue doesn't own the event" do
          let(:other_venue){ Factory.create(:venue) }
          let(:event){ Factory.create(:event, :venue => other_venue) }
          before{ request.env["HTTP_REFERER"] = 'example.com' }

          it "should display an error message" do
            put :update, :id => event.id, :event => { :name => 'New Event Name' }
            flash[:alert].should eq('You do not have permission to edit that event.')
          end

          it "should not update the event" do
            put :update, :id => event.id, :event => { :name => 'New Event Name' }
            event.reload.name.should_not eq('New Event Name')
          end
        end # context when current venue doesn't own the event
      end # PUT create
    end # when logged in as venue

    context "when not logged in" do
      describe "GET new" do
        it "should redirect to venue sign-in" do
          get :new
          response.should redirect_to(new_venue_session_url)
        end
      end

      describe "POST create" do
        it "should redirect to venue sign-in" do
          post :create
          response.should redirect_to(new_venue_session_url)
        end
      end

      describe "DELETE destroy" do
        let(:event){ Factory.create(:event) }

        it "should not delete the event" do
          expect{ delete :destroy, :id => event.id }.to_not change{ event.deleted }.from(false)
        end

        it "should redirect to venue sign in" do
          delete :destroy, :id => event.id
          response.should redirect_to(new_venue_session_url)
        end
      end

      describe "GET edit" do
        let(:event){ Factory.create(:event) }

        it "should redirect to venue sign in" do
          get :edit, :id => event.id
          response.should redirect_to(new_venue_session_url)
        end
      end

      describe "PUT update" do
        let(:event){ Factory.create(:event) }

        it "should redirect to venue sign in" do
          put :update, :id => event.id
          response.should redirect_to(new_venue_session_url)
        end
      end
    end
  end

  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/events" }.should route_to(:controller => "events", :action => "index")
    end

    it "recognizes and generates #show" do
      { :get => "/events/1" }.should route_to(:controller => "events", :action => "show", :id => "1")
    end

    it "recognizes index for specific day" do
      route_params = { :controller => "events", :action => "index", :year => "2011", :month => "4", :day => "5" }
      { :get => "/events/2011/4/5" }.should route_to( route_params )
    end

    it "recognizes index for day range" do
      route_params = { :controller => "events", :action => "index",
                       :from_year => "2011", :from_month => "4", :from_day => "5",
                       :to_year   => "2011", :to_month   => "4", :to_day   => "10" }
      { :get => "/events/from/2011/4/5/to/2011/4/10" }.should route_to( route_params )
    end

  end

end
