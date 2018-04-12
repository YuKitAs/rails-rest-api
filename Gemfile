source("https://rubygems.org")

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem("bcrypt", "~> 3.1.7")
gem("puma", "~> 3.7")
gem("rails", "~> 5.1.5")
gem("sqlite3")

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails"
end

group :development do
  gem "jwt"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "simple_command"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "rspec"
  gem "rspec-mocks"
end

gem("tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby])
