class Event < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 20

  CATEGORIES = [
    { :name => 'Sports',                 :stub => 'sports' },
    { :name => 'Community',              :stub => 'community' },
    { :name => 'Live Music',             :stub => 'live-music' },
    { :name => 'Benefit/Fundraiser',     :stub => 'benefit-fundraiser' },
    { :name => 'Religious',              :stub => 'religious' },
    { :name => 'Promotional',            :stub => 'promotional' },
    { :name => 'Speaking',               :stub => 'speaking' },
    { :name => 'Visual/Performing Arts', :stub => 'visual-performing-arts' },
    { :name => 'Culinary/Spirits',       :stub => 'culinary-spirits' },
    { :name => 'Other',                  :stub => 'other' }
  ]

  def self.valid_category_stubs
    CATEGORIES.map{ |c| c[:stub] }
  end

  def self.categories_for_select
    CATEGORIES.map{ |c| [c[:name], c[:stub]] }
  end

  BUSINESS_RELATIONS = [
    {:name => 'Company\'s Own Event', :stub => 1, :short_desc => ''},
    {:name => 'Company Endorsed Event', :stub => 2, :short_desc => 'Endorsed'}
  ]
  def self.valid_relation_stubs
    BUSINESS_RELATIONS.map{ |r| r[:stub] }
  end
  def self.relations_for_select
    BUSINESS_RELATIONS.map{|r| [r[:name], r[:stub].to_s]}
  end

  def self.cost_options_for_select
    [ ['Free', 'free'],
      ['Under $5', 'under-5'],
      ['Under $10', 'under-10'],
      ['Under $15', 'under-15'],
      ['Under $20', 'under-20'] ]
  end

  has_event_calendar
  belongs_to :city
  belongs_to :venue
  belongs_to :location
  has_many :views, :as => :viewable
  # can't use :all_blank because "state" is a drop-down pre-populated with "AL":
  accepts_nested_attributes_for :location, :reject_if => proc { |attributes| attributes['name'].blank? }

  validates_presence_of :start_at, :name, :category, :cost, :description, :venue, :business_relation
  validates_inclusion_of :category, :in => valid_category_stubs
  validates_inclusion_of :business_relation, :in => valid_relation_stubs
  validates_presence_of :other_category_name, :if => :other_category?

  attr_protected :deleted, :attending, :maybe_attending

  # Designed to take a timestamp at the beginning of a day, and a timestamp at
  # the end of a day
  #
  # Returns all events that are happening during that time frame *unless* they
  # end in the first 3 hours of it. The 3-hour restriction is designed to
  # prevent events that end late at night (ie, before 3am) from showing on the
  # day they technically end on
  # 
  # https://skitch.com/duien/fyk2x/photo1 -- the first two events are returned,
  # the third is not
  scope :between,   lambda { |from, to|
    where('(start_at BETWEEN :from AND :to) or ' +  # starts during the relevant time period
          '( (start_at,end_at) OVERLAPS (TIMESTAMP :from, TIMESTAMP :to) and ' + # or overlaps time period
            '(end_at NOT BETWEEN :from AND :end_from) )', # and doesn't end in first 3 hours of time period
          :from => from, :to => to, :end_from => from + 3.hours) }
  scope :upcoming,  lambda { where(['start_at >= ?', Time.now]) }
  scope :past,      lambda { where(['start_at < ?', Time.now]) }

  scope :with_cost, lambda { |cost|
      case cost
      when 'free'         then where(:cost => 0)
      when /under-(\d+)/  then where(['cost <= ?', $1])
      when /(\d+)-(\d+)/  then where(['cost >= ? AND cost <= ?', $1, $2])
      when /over-(\d+)/   then where(['cost >= ?', $1])
      end
  }

  # Pull all events for a city and those for "All locations" which are nil or 0.
  scope :for_city, lambda { |city| where(:city_id => [city.id, 0, nil]) }

  default_scope where(:deleted => false).order(:start_at)

  def location_name
    self.location_id? ? self.location.name : self.venue.location.name
  end

  def record_view(ip, referer = nil)
    self.views.create!(:ip_address => ip, :http_referer => referer)

  end

  def other_category?
    self.category == 'other'
  end

  def category_name
    other_category? ? self.other_category_name : CATEGORIES.detect{ |c| c[:stub] == self.category }[:name]
  end

  def relation_name
    relation = BUSINESS_RELATIONS.detect{ |r| r[:stub] == self.business_relation}
    relation.nil? ? '' : relation[:name]
  end
  def relation_short_desc
    relation = BUSINESS_RELATIONS.detect{ |r| r[:stub] == self.business_relation}
    relation.nil? ? '' : relation[:short_desc]
  end
  def organization_desc
    "#{venue.name} #{relation_short_desc}"
  end

  def phone_number
    the_location = self.location_id? ? self.location : self.venue.location
    phone = the_location.phone.gsub(/\D/, '').to_i
  end

  def balance
    self.views.count * self.price_per_view
  end

  def price_per_view
    Venue.category_for_stub(self.venue.category)[:price]
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  # A Ruby-based (non-ActiveRecord) filter that excludes/rejects events
  # that have a starting time in the local time zone no within the range.
  #
  # ex: if we have 3 events:
  #   [ event 1 starts at 17:00:00 EDT -04:00,
  #     event 2 starts at 21:00:00 EDT -04:00,
  #     event 3 starts at 23:00:00 EDT -04:00 ]
  #
  # and our filter is: 
  #   time_from => 18-00
  #   time_to   => 22-00
  #
  # We would remove any events where the from hour is greater than the start
  # and remove any events where to hour is less than the start.
  #
  # This is done because 22:00:00 EDT -04:00 is actually 00:00:00 GMT on the 
  # next day, and you can't compare hours to hours.
  #
  def self.filter_from_local_time(events, time_from)
    from_hour, from_minute  = time_from.split('-') # skip minute for now
    events.reject { |e| (from_hour.to_i > e.start_at.hour.to_i) }
  end

  def self.filter_to_local_time(events, time_to)
    to_hour, to_minute      = time_to.split('-')   # skip minute for now
    events.reject { |e| (to_hour.to_i   < e.start_at.hour.to_i) }
  end

  def self.from_organizations_followed_by(user)
    followed_organizations_ids = "SELECT venue_id FROM user_organizations
                         WHERE user_id = :user_id"
    where("venue_id IN (#{followed_organizations_ids})", user_id: user.id)
  end
end
