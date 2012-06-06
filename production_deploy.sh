#/bin/bash
git push origin master
git push production master
heroku pgbackups:capture --expire --app socialatitude-prod
heroku rake db:migrate --app socialatitude-prod
heroku restart --app socialatitude-prod
exit 0
