class AssemblyWorker
  include Sidekiq::Worker

  def perform(asset_id)
    asset = Asset.find(asset_id)
    if asset
      path = "uploads/assembled/#{asset_id}"
      FileUtils.mkdir_p path
      file = File.join path, asset.name
      # refridgeron, assemble
      File.open(file, 'wb') do |f|
        asset.chunks.order("id").each do |chunk|
          chunk_path = "uploads/assets/#{asset_id}/chunks/#{chunk.id}/#{asset.name}"
          f.write IO.read(chunk_path)
        end
      end

      # delete chunks
      # delete chunk records
      # mark asset as assembled
    end
  end
end
