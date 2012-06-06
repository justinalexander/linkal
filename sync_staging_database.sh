#/bin/bash
#Restores productions data into the staging environment

heroku pgbackups:restore SHARED_DATABASE `heroku pgbackups:url --app socialatitude-prod` --app socialatitude
exit 0
