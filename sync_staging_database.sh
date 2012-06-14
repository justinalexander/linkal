#/bin/bash
#Restores productions data into the staging environment

heroku pgbackups:restore SHARED_DATABASE `heroku pgbackups:url --app linkal` --app linkal
exit 0
