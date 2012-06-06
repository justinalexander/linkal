class View < ActiveRecord::Base
  belongs_to :viewable, :polymorphic => true
  validates_presence_of :viewable
end
