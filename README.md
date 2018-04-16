[![Build Status](https://travis-ci.org/YuKitAs/rails-rest-api.svg?branch=master)](https://travis-ci.org/YuKitAs/rails-rest-api)

# Rails Rest API

## Usage

### Setup

**Install all gems**:

```console
$ bundle install
```

**Update the database with new data model**:

```console
$ rake db:migrate
```

**Feed the database with default seeds**:

```console
$ rake db:seeds
```

**Start the web server on `http://localhost:3000` by default**:

```console
$ rails server
```

**Run all RSpec tests and Rubocop**:

```console
$ rake test
```

### Authentication

**Create a new user**:

```console
$ curl -X POST -H 'Content-type: application/json' -d '{"email": "testuser@email.com", "password": "testuser123"}' localhost:3000/register
```

**Authenticate a user**:

```console
$ curl -X POST -H 'Content-type: application/json' -d '{"email": "testuser@email.com", "password": "testuser123"}' localhost:3000/login
```

On successful login, `{"auth_token": <token>}` will be returned. This token will be expired after 24 hours.

### CRUD

To access the posts, add `-H 'Authorization: <token>'` to the header of every following request.

**List all posts**:

```console
$ curl -X GET localhost:3000/posts
```
  
**Show a single post by id**:

```console
$ curl -X GET localhost:3000/posts/<id>
```

The following actions are only for users with admin rights. A default admin user is definded in `db/seeds.rb`, use `{"email": "admin@email.com", "password": "admin123"}` to login as admin user.
  
**Create a new post**:

```console
$ curl -X POST -H 'Content-type: application/json' -d '{"title": "My title", "content": "My content"}' localhost:3000/posts
```

**Update an existing post by id**:

```console
$ curl -X PUT -H 'Content-type: application/json' -d '{"title": "My new title", "content": "My new content"}' localhost:3000/posts/<id>
```
  
**Delete an existing post by id**:

```console
$ curl -X DELETE localhost:3000/posts/<id>
```
