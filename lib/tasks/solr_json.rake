namespace :solr do
  desc 'delete all from solr'
  task :delete_solr => :environment do
    require 'pp'
    doc_ids = [
      "sample_video_history",
    ]
    doc_ids.each do |doc_id|
      puts doc_id
      pp Blacklight.solr.delete_by_id(doc_id)
    end
    pp Blacklight.solr.commit
  end

  desc 'delete paged collection from solr'
  task :delete_pages => :environment do
    require 'pp'
    base = ENV['BASE']
    max = ENV['MAX'].to_i
    (0..max).each do |number|
      doc_id = number > 0 ? %-#{base}_#{number}- : base
      puts doc_id
      pp Blacklight.solr.delete_by_id(doc_id)
    end
    pp Blacklight.solr.commit
  end

  desc 'delete directory of identifiers from solr'
  task :delete_dir => :environment do
    require 'pp'
    require 'find'
    Find.find(ENV['DIR']) do |path|
      if File.file?(path)
        doc_id = File.basename(path)
        puts doc_id
        pp Blacklight.solr.delete_by_id(doc_id)
      end
    end
    pp Blacklight.solr.commit
  end

  def fetch_env_file
    f = ENV['FILE']
    raise "Invalid file. Set the location of the file by using the FILE argument." unless f and File.exists?(f)
    f
  end


  namespace :index do
    #ripped directly from Blacklight demo application
    desc "index a directory of json files"
    task :json_dir=>:environment do
      require 'pp'
      input_file = ENV['FILE']
      if File.directory?(input_file)
        Dir.new(input_file).each_with_index do |f,index|
          if File.file?(File.join(input_file, f))
            puts "indexing #{f}"
            ENV['FILE'] = File.join(input_file, f)
            Rake::Task["solr:index:json"].invoke
            Rake::Task["solr:index:json"].reenable
          end
        end
        pp Blacklight.solr.commit
      end
    end

    #desc "index ead sample data from NCSU"
    #task :ead_sample_data => :environment do
    #  ENV['FILE'] = "#{RAILS_ROOT}/vendor/plugins/blacklight_ext_ead_simple/data/*"
    ##  Rake::Task["solr:index:ead_dir"].invoke
    #end

    # TODO Change this to index all the ua collection guides as well as manuscript
    # collections referred to within the db
    desc "Index a JSON file at FILE=<location-of-file>."
    task :json=>:environment do
      require 'nokogiri'
      require 'json'

      json = IO.read(fetch_env_file)
      solr_pre = JSON.parse(json)
      solr_doc = Hash.new
      solr_pre.each do |key,value|
        solr_doc[key.to_sym] = value
      end
      require 'pp'
      pp SolrService.add(solr_doc)
      pp SolrService.commit
      #pp solr_doc[:title_display]
      #if !solr_doc[:title_display].blank?
      #  response = Blacklight.solr.add solr_doc
      #  pp response; puts
      #end
      #pp Blacklight.solr.commit
    end
  end
end


def solrmarc_command_line(arguments)
  cmd = "java #{arguments[:solrmarc_mem_arg]} "
  cmd += " -Dsolr.hosturl=#{arguments[:solr_url]} " unless arguments[:solr_url].blank?
      
  cmd += " -Dsolrmarc.solr.war.path=#{arguments[:solr_war_path]}" unless arguments[:solr_war_path].blank?
  cmd += " -Dsolr.path=#{arguments[:solr_path]}" unless arguments[:solr_path].blank?
            
  cmd += " -jar #{arguments[:solrmarc_jar_path]} #{arguments[:config_properties_path]} #{arguments["MARC_FILE"]}"  
  return cmd  
end

# Computes arguments to Solr, returns hash
# Calculate default args based on location of rake file itself,
# which we assume to be in the plugin, or in the Rails executing
# this rake task, at RAILS_ROOT. 
def compute_arguments
  
  arguments  = {}

  arguments["MARC_FILE"] = ENV["MARC_FILE"]

  
  arguments[:config_properties_path] = ENV['CONFIG_PATH']


  # Find config in local app or plugin, possibly based on our RAILS_ENV (::Rails.env)
  unless arguments[:config_properties_path]
    app_site_path = File.expand_path(File.join(Rails.root, "config", "SolrMarc"))
    plugin_site_path = File.expand_path(File.join(Rails.root, "vendor", "plugins", "blacklight", "config", "SolrMarc"))

    [ File.join(app_site_path, "config-#{::Rails.env}.properties"  ),
      File.join( app_site_path, "config.properties"),
      File.join( plugin_site_path, "config-#{::Rails.env}.properties"),
      File.join( plugin_site_path, "config.properties"),
    ].each do |file_path|
      if File.exists?(file_path)
        arguments[:config_properties_path] = file_path
        break
      end
    end
  end
  
  #java mem arg is from env, or default

  arguments[:solrmarc_mem_arg] = ENV['SOLRMARC_MEM_ARGS'] || '-Xmx512m'
      
  # SolrMarc is embedded in the plugin, or could be a custom
  # one in local app.  
  arguments[:solrmarc_jar_path] = ENV['SOLRMARC_JAR_PATH'] || locate_path("lib", "SolrMarc.jar") 
  

      
  # solrmarc.solr.war.path and solr.path, for now pull out of ENV
  # if present. In progress. jrochkind 25 Apr 2011. 
  arguments[:solr_war_path] = ENV["SOLR_WAR_PATH"] if ENV["SOLR_WAR_PATH"]
  arguments[:solr_path] = ENV['SOLR_PATH'] if ENV['SOLR_PATH']

  # Solr URL, find from solr.yml, app or plugin
  # use :replicate_master_url for current env if present, otherwise :url
  # for current env. 
  # Also take jetty_path from there if present. 
    if c = Blacklight.solr_config
      arguments[:solr_url] = c[:url]    
      if c[:jetty_path]
        arguments[:solr_path] ||= File.expand_path(File.join(c[:jetty_path], "solr"), Rails.root)
        arguments[:solr_war_path] ||= File.expand_path(File.join(c[:jetty_path], "webapps", "solr.war"), Rails.root)
      end
  end
  
  return arguments
end
