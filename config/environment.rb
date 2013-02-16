# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BPDoc::Application.initialize!
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
Time::DATE_FORMATS[:ru_datetime] = "%d.%m.%Y %H:%M:%S"