class Language < ActiveRecord::Base
  attr_accessible :alpha2, :alpha3_bib, :alpha3_term, :name, :name_fr
end
