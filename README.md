[![Gem Version](https://badge.fury.io/rb/qualtrics_api.svg)](http://badge.fury.io/rb/qualtrics_api)
[![Dependency Status](https://gemnasium.com/pallymore/qualtrics_api.svg)](https://gemnasium.com/pallymore/qualtrics_api)
[![Build Status](https://travis-ci.org/CambridgeEducation/qualtrics_api.svg)](https://travis-ci.org/CambridgeEducation/qualtrics_api)

# QualtricsAPI

Ruby wrapper for Qualtrics REST ControlPanel API version 3.0.
[API Documents/Play Ground](https://co1.qualtrics.com/APIDocs/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'qualtrics_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qualtrics_api

## Usage

### Initialize

```ruby
client = QualtricsAPI.new "YOUR_QUALTRICS_API_KEY"
# => #<QualtricsAPI::Client:0x007fcb74496528 @api_token="YOUR_QUALTRICS_API_KEY">
```

### Surveys

To get all your surveys:

```ruby
client.surveys.fetch
# => #<QualtricsAPI::SurveyCollection:0x007fcb72cce350 ....>
```

You can also add a scopeId:

```ruby
client.surveys.fetch(scope_id: "someOwnerIdMaybe")
# => #<QualtricsAPI::SurveyCollection:0x007fcb72adaf21 ....>
```

After you have received results, you can search for a survey by id:

```ruby
survey = client.surveys.find("surveyIdHere")
# => #<QualtricsAPI::Survey:0x007fcb724f9468 @id="surveyIdHere" ...>
```

or just:

```ruby
survey = client.surveys["surveyIdHere"]
# =>  #<QualtricsAPI::Survey:0x007fcb724f9468 @id="surveyIdHere" ...>
```

### Panels

To get all the panels:

```ruby
client.panels.fetch
# => #<QualtricsAPI::PanelCollection:0x007f8769aae2c0 ....>
```

After you have received results, you can search for a panel by id:

```ruby
panel = client.panels.find("panelIdHere")
# => #<QualtricsAPI::Panel:0x007f876906f278 @id="panelIdHere" ...>
```

or just:

```ruby
panel = client.panels["panelIdHere"]
# => #<QualtricsAPI::Panel:0x007f876906f278 @id="panelIdHere" ...>
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
# => "https://some.amazon.s3.com/file/path?withTimeStamps=AndOtherStuff"
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
client = QualtricsAPI.new "YOUR QUALTRICS API TOKEN"
export = client.response_exports["someExportID"]
# => #<QualtricsAPI::ResponseExport:0x007fcb742e4e50 ....>
export.status
=> "99.99999%"
```

## Contributing

1. Fork it ( https://github.com/pallymore/qualtrics_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
