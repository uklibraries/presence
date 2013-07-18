class BagWorker
  include Sidekiq::Worker

  def perform(identifier)
    pairtree = Pairtree.at('sip-cache', :create => true)
    bag = BagIt::Bag.new pairtree.path_for(identifier)
  end
end
