#/bin/bash
git push origin staging
git push staging staging:master
heroku pgbackups:capture --expire --app socialatitude
heroku rake db:migrate --app socialatitude
heroku restart --app socialatitude

#after restart, heroku always throws an error, so curl to bypass that
curl socialatitude.heroku.com > /dev/null 2> /dev/null
curl socialatitude.heroku.com > /dev/null 2> /dev/null
exit 0

