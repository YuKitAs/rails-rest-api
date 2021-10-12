source("https://rubygems.org")

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem("bcrypt", "~> 3.1.7")
gem("jwt", "~> 2.1.0")
gem("puma", "~> 5.5.1")
gem("rails", "~> 5.2.3")
gem("rubocop")
gem("sqlite3")

group :development, :test do
  gem("byebug", platforms: [:mri, :mingw, :x64_mingw])
  gem("rspec-rails")
  gem("simple_command")
end

group :development do
  gem("listen", "~> 3.2.0")
  gem("spring")
  gem("spring-watcher-listen", "~> 2.0.0")
  gem("web-console", "~> 3.7.0")
end

group :test do
  gem("database_cleaner")
  gem("rspec")
  gem("rspec-mocks")
  gem("shoulda-matchers", "~> 4.4.0")
end

gem("tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby])
