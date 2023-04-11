class CacheUserFeedsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.each do |user|
      recommended = user.calculate_recommended_pins

      user.feed.destroy
      Feed.create(user: user, recommendations: recommended.to_json)
    end
  end
end
