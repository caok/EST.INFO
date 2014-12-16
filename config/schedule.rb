set :output, 'log/cron.log'

#every 5.minutes do
  #rake "crawler:feng"
#end

#every 6.minutes do
  #rake "crawler:imp3"
#end

#every 8.minutes do
  #rake "crawler:dgtle"
#end

#every 10.minutes do
  #rake "crawler:macx"
#end

#every 15.minutes do
  #rake "crawler:v2ex"
#end

every 20.minutes do
  rake "crawler:frequently"
end

every :hour do
  rake "crawler:sometime"
end

every '0 2 1 * *' do
  runner "Entry.clean"
end

every 1.day, :at => '1:30 am' do
  command "cd /home/estao/apps/estao/shared/public/en_images && find . -mtime +10 -type f | xargs rm -rf --silent >> log/cron.log 2>&1"
  command "cd /home/estao/apps/estao/shared/public/pd_images && find . -mtime +10 -type f | xargs rm -rf --silent >> log/cron.log 2>&1"
end
