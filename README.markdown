SociaLatitude
=============

This is a Rails3 application deployed to Heroku. It runs on Ruby 1.9.2.

Development Caveats
-------------------

Because of the way SSL is used, it's important to use `*_url` helpers instead of `*_path` so that the protocol constrainsts will be followed. For instance, using `venue_sign_in_path` will result in an error from a non-secure page, since that URL can only be accessed through HTTPS. Using `venue_sign_in_url` prevents this.

Bootstrapping
-------------

Make sure you're using the correct ruby version. I recommend using RVM to make
this easy. If you're using RVM, just create a `.rvmrc` file in the root of
the project. For example, mine is:

    rvm use 1.9.2@socialatitude

Install app dependencies:

    gem install bundler
    bundle install

Run migrations:

Make sure you set up postgres first, or change the database.yml to use sqlite3

    bundle exec rake db:migrate

Run the tests:

    bundle exec rake guard
    
Run the server:

    rails server

### Connect to Heroku

First, you'll need to get either the app owner or another developer to add to you the Heroku projects:

    heroku sharing:add you@highgroove.com

Next, you'll need to set up git remotes for the two Heroku projects:

    git remote add staging git@heroku.com:socialatitude.git
    git remote add production git@heroku.com:socialatitude-prod.git

    git checkout production

Now you can deploy to staging or production by pushing to the appropriate remote. We use the `staging` branch to deploy to staging, and the `master` branch to deploy to production. Heroku always uses the branch `master` to run your app out of, so you need to push the local branch to a branch named `master` on the remote. Because of this, it's much easier to push a branch named `master` locally, so we use that for production to prevent accidentally pushing staging code into production.

To deploy to staging: 

    git push staging staging:master

To deploy to master:

    git push production master

Because you have two Heroku projects configured in a single codebase, you'll need to specify which app you want to use whenever you use a Heroku command. For instance, to check the production logs you can use one of the following commands:

    heroku logs --app socialatitude-prod
    heroku logs --remote production

Heroku Setup
------------

When setting up a new Heroku server, make sure to use the `bamboo-mri-1.9.2` stack. The only other additional config is to set the timezone on the server:

    heroku stack:migrate bamboo-mri-1.9.2
    heroku config:add TZ='Eastern Time (US & Canada)'

You'll also want to add the following addons:

    custom_domains:basic
    logging:expanded
    sendgrid:free
    shared-database:5mb
    
SSL Setup
------------

See: http://devcenter.heroku.com/articles/ssl

Generated an SSL Certificate Signing Request using:

http://www.akadia.com/services/ssh_test_certificate.html

Steps 1 and 2

Used 2048 for key size.

Submitted to Client to get signed / purchased from GoDaddy.

Client gave back a .zip file with .crt and Intermediate files.  Combine those into a pem file like so:

cat doc/socialatitude.com.crt doc/sf_bundle.crt doc/socialatitude.key > doc/socialatitude.com.pem

Tried to add, but it needed some passphrase info removed:

heroku ssl:add doc/socialatitude.com.pem doc/socialatitude.key --app socialatitude-prod !   Pem is invalid / Key doesn't match the PEM certificate

Ran:

openssl rsa -in doc/socialatitude.com.pem -out doc/socialatitude-no-passphrase.com.pem

openssl x509 -in doc/socialatitude.com.pem >> doc/socialatitude-no-passphrase.com.pem

openssl rsa -in doc/socialatitude.key -out doc/socialatitude-no-passphrase.key

This worked:

heroku ssl:add doc/socialatitude-no-passphrase.com.pem doc/socialatitude-no-passphrase.key --app socialatitude-prod

Added certificate to www.socialatitude.com, expiring in 2012/05/19 20:00:20 -0700

Additional Guides followed:

http://erikonrails.snowedin.net/?p=245

===

Continuous Integration

This project is setup to run in the Tddium (www.tddium.com) Continuous Integration environment.  Tddium service hooks are deployed on github and Tddium is set to test the staging and master branches.

In order to get the Tddium notification emails, you will need to get added as a collaborator.  Ask Daniel Rice for access and I can add you!

===


