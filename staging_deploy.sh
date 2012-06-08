#/bin/bash
git push origin master
git push staging staging:master
heroku pgbackups:capture --expire --app linkal
heroku run rake db:migrate --app linkal
heroku restart --app linkal

#after restart, heroku always throws an error, so curl to bypass that
curl linkal.heroku.com > /dev/null 2> /dev/null
curl linkal.heroku.com > /dev/null 2> /dev/null
exit 0
