# Rails Rest API

## Usage

**Install all gems in `Gemfile`**:

```console
$ bundle install
```

**Update the database with new data model**:

```console
$ rake db:migrate
```

**Feed the database with default posts**:

```console
$ rake db:seeds
```

**Run all unit tests with RSpec**:

```console
$ rspec spec
```

**Start the web server on `http://localhost:3000` by default**:

```console
$ rails server
```

**List all posts**:

```console
$ curl -X GET localhost:3000/posts
```
  
**Show a single post by id**:

```console
$ curl -X GET localhost:3000/posts/<id>
```
  
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
