set :output, "#{path}/log/cron.log"
set :environment, :production

every 1.minutes do
  runner "Gift.pull_from_hat"
end

# every 1.days do
#   runner "User.destroy_old_guests"
# end