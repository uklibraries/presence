class MintWorker
  include Sidekiq::Worker

  def perform(package_id)
    package = Package.find(package_id)
    if package.identifier.nil? or package.identifier.strip == ''
      minter = Minter.new
      package.update_attribute(:identifier, minter.mint)
    end
  end
end
