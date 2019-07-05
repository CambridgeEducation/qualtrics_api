[![Gem Version](https://badge.fury.io/rb/qualtrics_api.svg)](http://badge.fury.io/rb/qualtrics_api)
[![Build Status](https://travis-ci.org/CambridgeEducation/qualtrics_api.svg)](https://travis-ci.org/CambridgeEducation/qualtrics_api)

### Maintenance Mode

Hi - Cambridge Education have moved away from Qualtrics and started using a different survey platform since 2018.
As a result of that - we've stopped developing API integrations with Qualtrics, this repo is officially in maintenance mode.
However, please feel free to open pull requests / ask questions, I will try my best to review them. Thanks!

- Yurui

# QualtricsAPI

Ruby wrapper for Qualtrics REST ControlPanel API version 3.0.
[API Documents/Play Ground](https://api.qualtrics.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qualtrics_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qualtrics_api

## Dependencies

Currently this gem is built & tested with Ruby 2.3.x.
Confirmed working with Ruby 2.4.x.

Requires Ruby >= 2.3

```ruby
"faraday", "~> 0.13.1"
"faraday_middleware", "~> 0.12.2"
"virtus", "~> 1.0"
```

## Usage

### Initialize

```ruby
QualtricsAPI.configure do |config|
  # mandatory
  config.api_token = "YOUR_QUALTRICS_API_KEY"

  # optionally - you can provide a data center id
  config.data_center_id = "co1" #defaults to co1
end
```

### Surveys

To enumerate all your surveys:

```ruby
QualtricsAPI.surveys.each do |survey|
  # => #<QualtricsAPI::Survey:0x007fcb72cce350 ....>
end
```

To enumerate individual pages:
```ruby
QualtricsAPI.surveys.each_page do |page|
  page.each do |survey|
    # => #<QualtricsAPI::Survey:0x007fcb72cce350 ....>
  end
end
```

You can search for a survey by id:

```ruby
survey = QualtricsAPI.surveys.find("surveyIdHere")
# => #<QualtricsAPI::Survey:0x007fcb724f9468 @id="surveyIdHere" ...>
```

or just:

```ruby
survey = QualtricsAPI.surveys["surveyIdHere"]
# =>  #<QualtricsAPI::Survey:0x007fcb724f9468 @id="surveyIdHere" ...>
```

#### Export Responses From a Survey

Once you have a `survey` object (`QualtricsAPI::Survey`], you can start
an export like so:

(You can pass any supported options in ruby style!)

```ruby
export_service = survey.export_responses({ start_date: "2015-03-03 11:11:10" })
# => #<QualtricsAPI::Services::ResponseExportService:0x007fcb742e4e50 ....>
```

or you can configure it laster...

```ruby
export_service = survey.export_responses
# => #<QualtricsAPI::Services::ResponseExport:0x007fcb742e4e50 ....>
export_service.start_date = "2015-03-03 11:11:10"
```
(See Qualtrics API doc for a full list of options)

Then start the export:

```ruby
export = export_service.start
# => #<QualtricsAPI::ResponseExport:0x007fcb742e4e50 ....>
```

Then to check the progress

```ruby
export.status
# => "20.333333%"

export.completed?
# => fasle

# call again to refresh
export.status
# => "100%"

export.completed?
# => true
```

Once it's finished, you can get the response file URL:
```ruby
export.file_url
# => "https://co1.qualtrics.com/API/v3/responseexports/ES_id/file"
```

and download the file:
```ruby
export.open # creates an IO object connected to the given stream
```

#### Checking status on a previous response export

Each response export yeilds an `id`

```ruby
export = survey.export_responses({ }).start
# => #<QualtricsAPI::ResponseExport:0x007fcb742e4e50 ....>

export.id
# => "someExportID"
```

You can save it somewhere in your app and check back later (if you know
it's gonna take a while!)

```ruby
export = QualtricsAPI.response_exports["someExportID"]
# => #<QualtricsAPI::ResponseExport:0x007fcb742e4e50 ....>
export.status
=> "99.99999%"
```

### Panels

To enumerate all the panels:

```ruby
QualtricsAPI.panels.each do |panel|
  # => #<QualtricsAPI::Panel:0x007f8769aae2c0 ....>
end
```

To enumerate individual pages:

```ruby
QualtricsAPI.panels.each_page do |page|
  page.each do |survey|
    # => #<QualtricsAPI::Panel:0x007f8769aae2c0 ....>
  end
end
```

You can search for a panel by id:

```ruby
panel = QualtricsAPI.panels.find("panelIdHere")
# => #<QualtricsAPI::Panel:0x007f876906f278 @id="panelIdHere" ...>
```

or just:

```ruby
panel = QualtricsAPI.panels["panelIdHere"]
# => #<QualtricsAPI::Panel:0x007f876906f278 @id="panelIdHere" ...>
```

#### Panel Members

To import a batch of panel members:

```ruby
panel = QualtricsAPI.panels.find("panelIdHere")
members = [QualtricsAPI::PanelMember.new(first_name: 'John', last_name: 'Doe', email: 'test@test.com')]
panel.import_members(members)
=> #<QualtricsAPI::PanelImport:0x007fb7db984668 ...>
```

A `PanelImport` record is returned, you can use it to check the status of panel import:

```ruby
members = [QualtricsAPI::PanelMember.new(first_name: 'John', last_name: 'Doe', email: 'test@test.com')]
panel_import = panel.members.import_members(members)
=> #<QualtricsAPI::PanelImport:0x007fb7db984668 ...>
panel_import.status
=> "99.99999%"
panel_import.update_status
panel_import.status
=> "100.0%"
```

To add a single panel member to a panel:

```ruby
panel = QualtricsAPI.panels.find("panelIdHere")
member = QualtricsAPI::PanelMember.new(first_name: 'John', last_name: 'Doe', email: 'test@test.com')
panel.create(member)
```

A new `PanelMember` record is returned on success; this will give you the ID of the newly created member.

## Contributing

1. Fork it ( https://github.com/pallymore/qualtrics_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
