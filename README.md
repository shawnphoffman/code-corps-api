# Code Corps Rails API

[![Code Climate](https://codeclimate.com/github/code-corps/code-corps-api/badges/gpa.svg)](https://codeclimate.com/github/code-corps/code-corps-api) [![Test Coverage](https://codeclimate.com/github/code-corps/code-corps-api/badges/coverage.svg)](https://codeclimate.com/github/code-corps/code-corps-api/coverage) [![Dependency Status](https://gemnasium.com/code-corps/code-corps-api.svg)](https://gemnasium.com/code-corps/code-corps-api)
 [ ![Codeship Status for code-corps/code-corps-api](https://codeship.com/projects/f79468b0-fd8d-0132-18d2-123cfeffb5ea/status)](https://codeship.com/projects/87849)
[![Slack Status](http://slack.codecorps.org/badge.svg)](http://slack.codecorps.org)

The Code Corps API is an open source Rails::API backend that powers the Code Corps platform. It includes:

- developer and project matchmaking
- project management tooling
- a donations engine that distributes donations to projects

## Developer installation guide

### Install Rails, PostgreSQL, and Redis

We need to install the Ruby on Rails framework, the PostgreSQL database, and the Redis data store.

1. [Install Rails](http://installrails.com/).
2. Install and configure PostgreSQL 9.3+.
  1. Run `postgres -V` to see if you already have it.
  2. Make sure that the server's messages language is English; this is [required](https://github.com/rails/rails/blob/3006c59bc7a50c925f6b744447f1d94533a64241/activerecord/lib/active_record/connection_adapters/postgresql_adapter.rb#L1140) by the ActiveRecord Postgres adapter.
3. Install and make sure you can run redis:
   * Follow the [official quickstart guide](http://redis.io/topics/quickstart)
   * It's best to install it as a service instead of running it manually
   * To make sure everything works and the service is running, execute `redis-cli ping` in the console. It should respond with `PONG`

### Set up the Rails app

1. Run `bin/setup` to set up and seed the database.
2. Try running the specs: `bundle exec rake spec`

From here, we need to start the web server, Redis, and Sidekiq processes. You can either:

#### Use [foreman](https://github.com/ddollar/foreman) to run your application's processes
3. Stop your existing `redis-server` process
4. Run the api with `foreman start -f Procfile.dev`. This will start any service listed in that Procfile.

#### Alternatively, run your application's processes individually
3. You already have `redis-server` running. In the future, you'll need to run it, as well.
4. Start Sidekiq with `bundle exec sidekiq`
5. Start the Rails server with `rails s`


### To make sure the API is running properly

Point your browser (or make a direct request) to http://api.lvh.me:3000/ping. There should be a `{"ping":"pong"}` response from it.


### Testing helpers

We've written some convenience helpers to help with API testing. The helpers are found in `spec/support/helpers` as:

- `ApiHelpers`
  - `authenticate` which is an authentication helper that uses OAuth2 to authenticate requests and return a token used to make future requests.
- `RequestHelpers`
  - `json` which returns the JSON of the last response as a Ruby object
  - `authenticated_get(path, args, token)` (and `_post`, `_put`, `_delete`) which takes the URL path, any arguments, and the token generated by the `authenticate` method above. You can grep for good examples of these in action.

These helpers are included in specs by default via the `rails_helper`. You can just call these methods directly.


### Working with Ember

The CodeCorps API is intended to work alongside a client written in Ember. For that purpose, the rails application exposes all of it's API endpoints behind an `api.` subdomain.

On the Ember client side of things, we use [`ember-cli-deploy`](https://github.com/ember-cli/ember-cli-deploy) with a `redis` plugin to deploy the client application to redis. Multiple revisions are maintained this way.

Any server request pointing to the main domain and not the `api.` subdomain is redirected to `ember_index_controller#index`. There, depending on the remainder of the request path and the current environment, a specific revision of the ember app is retrieved from redis and rendered. This can be
* the development revision, if the current environment is development
* a specific deployed revision in production if the request contains a revision parameter in SHORT_UUID format
* the latest deployed revision in production if the request does not contain a revision parameter
* A plain text string containing "INDEX NOT FOUND" if a revision was specified, but the key for the specified revision was not found by redis


## Built with

- [Rails::API](https://github.com/rails-api/rails-api) — Our backend API is a Rails::API app which uses JSON API to respond RESTfully to requests.
- [Ember.js](https://github.com/emberjs/ember.js) — Our frontend is an Ember.js app that communicates with the Rails API.
- [PostgreSQL](http://www.postgresql.org/) — Our primary data store uses Postgres.
