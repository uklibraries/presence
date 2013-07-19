class Retention < ActiveRecord::Base
  attr_accessible :name

  def self.temporal
    Retention.where(:name => 'temporal').first
  end
end
