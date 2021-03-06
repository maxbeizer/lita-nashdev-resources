# lita-nashdev-resources

A [lita](https://lita.io) plugin to allow people to suggest resources to be
added to the [NashDev Resources
repo](https://github.com/maxbeizer/nashdev-resources) via GitHub Issues.

## Installation

Add lita-nashdev-resources to your Lita instance's Gemfile:

``` ruby
gem "lita-nashdev-resources"
```

## Configuration

Requires a `RESOURCE_ISSUE_TOKEN` config var to POST to issue to repo

example in `lita_config.rb` :
```ruby
Lita.configure do |config|
  config.handlers.nashdev_resources.issue_token = ENV['RESOURCE_ISSUE_TOKEN']
end
```

## Usage

```
lita resource me https://some-resource.com
lita resource https://some-resource.com
```
