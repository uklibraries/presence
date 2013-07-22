module Presence
  module SolrHelper
    module Authorization
      def self.included base
        base.solr_search_params_logic << :show_only_user_records
      end

      def show_only_user_records solr_parameters, user_parameters
        if current_user
          unless can? :manage, :catalog
            solr_parameters[:fq] ||= []
            solr_parameters[:fq] << "username_s:#{current_user.username}"
          end
        else
          solr_parameters[:fq] ||= []
          solr_parameters[:fq] << "access_t:public"
        end
      end
    end
  end
end
