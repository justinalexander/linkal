require 'spec_helper'

describe Event do
  let(:attrs) { 
    v = FactoryGirl.create(:venue)
    FactoryGirl.attributes_for(:event).merge(:venue_id => v.id)
  }

  it "should be valid with valid attributes" do
    event = Event.new(attrs)
    event.should be_valid
  end

  %w(start_at name category description venue_id).each do |required_attribute|
    it "should be invalid without #{required_attribute}" do
      invalid_attrs = attrs.dup
      invalid_attrs.delete(required_attribute.to_sym)
      event = Event.new(invalid_attrs)
      event.should_not be_valid
    end
  end

  describe ".between" do
    before do
      Timecop.freeze(Time.now)
      (-2..2).each{ |n| FactoryGirl.create(:event, :start_at => n.days.from_now) }
    end
    subject{ Event.between(1.day.ago, 1.day.from_now) }

    it "should return events with start_at between specified values" do
      subject.should have(3).events
    end

    context "multi-day events" do
      let(:multi_day){ FactoryGirl.create(:event, :start_at => Time.parse("may 19, 10:00am"),
                                              :end_at   => Time.parse("may 20, 6:00pm")) }
      let(:runs_late){ FactoryGirl.create(:event, :start_at => Time.parse("may 19, 7:00pm"),
                                              :end_at   => Time.parse("may 20, 2:00am")) }
      it "should find event with overlap" do
        multi_day # create before running query

        time_start = Time.parse("may 20").beginning_of_day
        time_end   = Time.parse("may 20").end_of_day
        Event.between(time_start, time_end).should include(multi_day)
      end

      it "should not find event ending before 3am" do
        runs_late # create before running query

        time_start = Time.parse("may 20").beginning_of_day
        time_end   = Time.parse("may 20").end_of_day
        Event.between(time_start, time_end).should_not include(runs_late)
      end
    end
  end

  describe ".past" do
    before do
      Timecop.freeze(Time.at(Time.now.to_i))
      (-2..2).each{ |n| FactoryGirl.create(:event, :start_at => n.days.from_now) }
    end
    subject{ Event.past }
    it "should return events with start_at before now" do
      subject.should have(2).events
      subject.each do |event|
        event.start_at.should be < Time.now
      end
    end
  end

  describe ".with_cost" do
    before do
      [0, 1, 5, 7, 10].each do |cost|
        FactoryGirl.create(:event, :cost => cost)
      end
    end

    it "should return events with zero cost when 'free'" do
      Event.with_cost('free').tap do |results|
        results.should have(1).event
        results.first.cost.should == 0
      end
    end

    it "should return results with cost <= 5 when 'under-5'" do
      Event.with_cost('under-5').tap do |results|
        results.should have(3).events
        results.each{ |r| r.cost.should be <= 5 }
      end
    end

    it "should return results with cost >= 7 when 'over-7'" do
      Event.with_cost('over-7').tap do |results|
        results.should have(2).events
        results.each{ |r| r.cost.should be >= 7 }
      end
    end

    it "should return results with cost between two values (inclusive) when like '1-7'" do
      Event.with_cost('1-7').tap do |results|
        results.should have(3).events
        results.each{ |r| r.cost.should be >= 1 }
        results.each{ |r| r.cost.should be <= 7 }
      end
    end

  end

  it "should not allow setting 'attending' through mass assignment" do
    event = FactoryGirl.create(:event)
    expect{
      event.update_attributes(:attending => 5)
      event.reload }.to_not change{ event.attending }
  end

  it "should not allow setting 'maybe_attending' through mass assignment" do
    event = FactoryGirl.create(:event)
    expect{
      event.update_attributes(:maybe_attending => 5)
      event.reload }.to_not change{ event.maybe_attending }
  end

  it "should not allow setting 'deleted' through mass assignment" do
    event = FactoryGirl.create(:event)
    event.should_not be_deleted

    event.update_attributes(:deleted => true)
    event.should_not be_deleted
  end

  it "should return only non-deleted events by default" do
    FactoryGirl.create(:event)
    deleted_event = FactoryGirl.create(:event, :deleted => true)

    Event.all.should_not include(deleted_event)
  end

  it "should return other_category_name if category is other" do
    event = FactoryGirl.create(:event, :category => 'other', :other_category_name => 'Something Awesome')
    event.category_name.should eq('Something Awesome')
  end

  it "should only allow valid category names" do
    event = FactoryGirl.build(:event, :category => 'bogus')
    event.should_not be_valid
  end

  it "should require other_category_name if category is other" do
    event = FactoryGirl.build(:event, :category => 'other')
    event.should_not be_valid
  end

  describe "#other_category?" do
    it "should return true if category is 'other'" do
      FactoryGirl.build(:event, :category => 'other').should be_other_category
    end

    it "should return false if category is not 'other'" do
      FactoryGirl.build(:event, :category => 'performing-visual-arts').should_not be_other_category
    end
  end

  describe "#balance" do
    let(:event){ FactoryGirl.create(:event) }
    before{ 5.times{ event.record_view('127.0.0.1') } }

    it "should calculate" do
      event.balance.should eq(2.5)
    end
  end

  describe "from_organizations_followed_by" do
    before :each do
      @org = FactoryGirl.create(:venue)
      @event = FactoryGirl.create(:event, venue_id: @org.id )

      @user = FactoryGirl.create(:user)
      @user.user_organizations.create(venue_id: @org.id)
    end

    it "should include followed organizations events" do
      Event.from_organizations_followed_by(@user).should include(@event)
    end

  end
end
