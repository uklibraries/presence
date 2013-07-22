# -*- encoding : utf-8 -*-
require 'blacklight/catalog'
require 'presence/solr_helper/authorization'

class CatalogController < ApplicationController  

  include Blacklight::Catalog
  include Presence::SolrHelper::Authorization

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = { 
      :qt => 'search',
      :rows => 10 
    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or 
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    #config.default_document_solr_params = {
    #  :qt => 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # :fl => '*',
    #  # :rows => 1
    #  # :q => '{!raw f=id v=$id}' 
    #}

    # solr field configuration for search results/index views
    config.index.show_link = 'title_display'
    config.index.record_display_type = 'format'

    # solr field configuration for document/show views
    config.show.html_title = 'title_display'
    config.show.heading = 'title_display'
    config.show.display_type = 'format'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    config.add_facet_field 'who_s', :label => 'Who'
    config.add_facet_field 'what_s', :label => 'What'
    config.add_facet_field 'pub_date', :label => 'When'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    config.add_index_field 'who_s', :label => 'Who:'
    config.add_index_field 'what_s', :label => 'What:'
    config.add_index_field 'when_dt', :label => 'When:'
    #config.add_index_field 'title_display', :label => 'Title:' 
    #config.add_index_field 'title_vern_display', :label => 'Title:' 
    #config.add_index_field 'author_display', :label => 'Author:' 
    #config.add_index_field 'author_vern_display', :label => 'Author:' 
    ##config.add_index_field 'format', :label => 'Format:' 
    #config.add_index_field 'language_facet', :label => 'Language:'
    #config.add_index_field 'published_display', :label => 'Published:'
    #config.add_index_field 'published_vern_display', :label => 'Published:'
    #config.add_index_field 'lc_callnum_display', :label => 'Call number:'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
#    config.add_show_field 'title_display', :label => 'Title:' 
#    config.add_show_field 'title_vern_display', :label => 'Title:' 
#    config.add_show_field 'subtitle_display', :label => 'Subtitle:' 
#    config.add_show_field 'subtitle_vern_display', :label => 'Subtitle:' 
#    config.add_show_field 'author_display', :label => 'Author:' 
#    config.add_show_field 'author_vern_display', :label => 'Author:' 
#    config.add_show_field 'format', :label => 'Format:' 
#    config.add_show_field 'url_fulltext_display', :label => 'URL:'
#    config.add_show_field 'url_suppl_display', :label => 'More Information:'
#    config.add_show_field 'language_facet', :label => 'Language:'
#    config.add_show_field 'published_display', :label => 'Published:'
#    config.add_show_field 'published_vern_display', :label => 'Published:'
#    config.add_show_field 'lc_callnum_display', :label => 'Call number:'
#    config.add_show_field 'isbn_t', :label => 'ISBN:'
    config.add_show_field 'who_s', :label => 'Who:'
    config.add_show_field 'what_s', :label => 'What:'
    config.add_show_field 'when_dt', :label => 'When:'
    #config.add_show_field 'title_s', :label => 'Title:'
    #config.add_show_field 'source_t', :label => 'Source:'
    #config.add_show_field 'creator_t', :label => 'Creator:'
    #config.add_show_field 'contributor_t', :label => 'Contributor:'
    #config.add_show_field 'subject_t', :label => 'Subject:'
    #config.add_show_field 'publisher_t', :label => 'Publisher:'
    #config.add_show_field 'date_original_s', :label => 'Date:'
    #config.add_show_field 'date_submit_s', :label => 'Repository Ingest Date:'
    #config.add_show_field 'date_upload_s', :label => 'Upload Date:'
    #config.add_show_field 'date_year_i', :label => 'Year:'
    #config.add_show_field 'date_terminal_s', :label => 'Terminal Date:'
    #config.add_show_field 'format_t', :label => 'Format:'
    #config.add_show_field 'identifier_s', :label => 'Identifier:'
    #config.add_show_field 'arch_identifier_s', :label => 'Archival Storage Identifier:'
    #config.add_show_field 'type_t', :label => 'Type:'
    #config.add_show_field 'language_t', :label => 'Language:'
    #config.add_show_field 'rights_t', :label => 'Rights:'
    #config.add_show_field 'description_t', :label => 'Description:'
    #config.add_show_field 'relation_s', :label => 'Relation:'
    #config.add_show_field 'coverage_t', :label => 'Coverage:'
    config.add_show_field 'access_t', :label => 'Access:'
    config.add_show_field 'retention_t', :label => 'Retention Level:'
    config.add_show_field 'retention_dt', :label => 'Retention Date:'
    config.add_show_field 'status_s', :label => 'Status:'


    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 
    
    #config.add_search_field 'all_fields', :label => 'All Fields'
    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
#    config.add_search_field('title') do |field|
#      # solr_parameters hash are sent to Solr as ordinary url query params. 
#      field.solr_parameters = { :'spellcheck.dictionary' => 'title' }
#
#      # :solr_local_parameters will be sent using Solr LocalParams
#      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
#      # Solr parameter de-referencing like $title_qf.
#      # See: http://wiki.apache.org/solr/LocalParams
#      field.solr_local_parameters = { 
#        :qf => '$title_qf',
#        :pf => '$title_pf'
#      }
#    end
    
#    config.add_search_field('author') do |field|
#      field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
#      field.solr_local_parameters = { 
#        :qf => '$author_qf',
#        :pf => '$author_pf'
#      }
#    end
#    
#    # Specifying a :qt only to show it's possible, and so our internal automated
#    # tests can test it. In this case it's the same as 
#    # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
#    config.add_search_field('subject') do |field|
#      field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
#      field.qt = 'search'
#      field.solr_local_parameters = { 
#        :qf => '$subject_qf',
#        :pf => '$subject_pf'
#      }
#    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', :label => 'relevance'
    config.add_sort_field 'pub_date_sort desc, title_sort asc', :label => 'year'
    config.add_sort_field 'author_sort asc, title_sort asc', :label => 'author'
    config.add_sort_field 'title_sort asc, pub_date_sort desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  def download
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end

  def share
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end

  def revise
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end

  def withdraw
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end

  def view_contents
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key, params[:id])
    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end

  # Email Action (this will render the appropriate view on GET requests and process the form and send the email on POST requests)
  def email
    @response, @documents = get_solr_response_for_field_values(SolrDocument.unique_key,params[:id])
    if request.post?
      if params[:from]
        url_gen_params = {:host => request.host_with_port, :protocol => request.protocol}
        
        if params[:from].length > 0
          email = RecordMailer.email_record(@documents, {:from => params[:from], :message => params[:message]}, url_gen_params)
        else
          flash[:error] = I18n.t('blacklight.email.errors.from.blank')
        end
      else
        flash[:error] = I18n.t('blacklight.email.errors.from.blank')
      end

      unless flash[:error]
        email.deliver 
        flash[:success] = "Email sent"
        redirect_to catalog_path(params['id']) unless request.xhr?
      end
    end

    unless !request.xhr? && flash[:success]
      respond_to do |format|
        format.js { render :layout => false }
        format.html
      end
    end
  end
end 
