#/bin/bash

#// old stuff
#git push origin master
#git push production master
#heroku pgbackups:capture --expire --app socialatitude-prod
#heroku rake db:migrate --app socialatitude-prod
#heroku restart --app socialatitude-prod
#exit 0
git push origin master
git push staging master
git push staging staging:master
heroku pgbackups:capture --expire --app linkal
heroku run rake db:migrate --app linkal
heroku restart --app linkal

#after restart, heroku always throws an error, so curl to bypass that
curl senkd.com > /dev/null 2> /dev/null
curl senkd.com > /dev/null 2> /dev/null
exit 0
