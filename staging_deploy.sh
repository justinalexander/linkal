#/bin/bash
git push staging master
git push staging staging:master
heroku pgbackups:capture --expire --app linkal
heroku run rake db:migrate --app linkal
heroku restart --app linkal
heroku config:add RAILS_ENV=staging RACK_ENV=staging --app linkal

#after restart, heroku always throws an error, so curl to bypass that
curl linkal.heroku.com > /dev/null 2> /dev/null
curl linkal.heroku.com > /dev/null 2> /dev/null
exit 0
