#/bin/bash
APP_NAME="socialatitude-prod"
DB_NAME="socialatitude_development"

echo "Restoring Production Database to your local postgres server..."

echo "Capturing Production Database..."
heroku pgbackups:capture --expire --app $APP_NAME

echo "Downloading Database Dump..."
curl -o tmp/latest.dump `heroku pgbackups:url --app $APP_NAME`

echo "Restoring Database Locally..."
pg_restore --clean --no-acl --no-owner -h localhost -U postgres -d $DB_NAME tmp/latest.dump

echo "Cleaning up...."
rm -f tmp/latest.dump

echo "Done!"
exit 0
