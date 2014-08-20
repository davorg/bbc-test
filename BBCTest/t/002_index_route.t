use Test::More;
use strict;
use warnings;

# the order is important
use BBCTest;
use Dancer::Test;

route_exists [GET => '/'], 'a route handler is defined for /';
response_status_is ['GET' => '/'], 200, 'response status is 200 for /';

route_exists [GET => '/video'], 'a route handler is defined for /video';
response_status_is ['GET' => '/video'], 200, 'response status is 200 for /video';

done_testing;