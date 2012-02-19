require 'rack/request'
require 'rack/response'
$: << File.join(File.dirname(__FILE__),"middleware")
require 'my_middleware'

use RackCookieSession
use RackSession
run RackDebug.new
