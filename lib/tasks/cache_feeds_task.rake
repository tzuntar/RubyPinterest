desc "Caches feeds for all users"
task :cache_feeds_task => :environment do
  CacheUserFeedsJob.perform_later
end
