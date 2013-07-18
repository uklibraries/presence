# This patch to BagIt::Manifest allows incremental
# updating of manifests. 
# 
# --mps 2013-07-18

module BagIt
  module Manifest
    def checksum_file!(bag_file)
      rel_path = Pathname.new(bag_file).relative_path_from(Pathname.new(bag_dir)).to_s

      sha1 = Digest::SHA1.file bag_file
      open(manifest_file(:sha1), 'a') { |io| io.puts "#{sha1} #{rel_path}" }

      md5 = Digest::MD5.file bag_file
      open(manifest_file(:md5), 'a') { |io| io.puts "#{md5} #{rel_path}" }
      tagmanifest!
    end
  end
end

class AssemblyWorker
  include Sidekiq::Worker

  def perform(asset_id)
    asset = Asset.find(asset_id)
    package = Package.find(asset.package_id)
    pairtree = Pairtree.at('sip-cache', :create => true)
    if asset
      bag_dir = pairtree.path_for(package.identifier)
      FileUtils.mkdir_p bag_dir
      bag = BagIt::Bag.new bag_dir
      bag.add_file(asset.name) do |io|
        asset.chunks.order("id").each do |chunk|
          chunk_path = "uploads/assets/#{asset_id}/chunks/#{chunk.id}/#{asset.name}"
          io.write IO.read(chunk_path)
        end
      end
      bag.checksum_file!(File.join(bag.data_dir, asset.name))

      asset.chunks.each do |chunk|
        chunk.remove_chunk!
        chunk.delete!
      end

      asset.update_attribute(:assembled, true)
    end
  end
end
