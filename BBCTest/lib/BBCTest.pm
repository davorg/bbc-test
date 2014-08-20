package BBCTest;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/video' => sub {
    my $id = param('id');
    return $id;
};

true;
