package BBCTest;
use Dancer ':syntax';
use DateTime;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/video' => sub {
    content_type => 'application/xml';
    my $id = param('id');
    my $start = DateTime->now;
    my $end = $start->clone->add({ seconds => 3600 });
    return qq[<vidauth sig="yyyyy">
  <id>$id</id>
  <authid>xxxxx</authid>
  <available start="$start" end="$end"/>
</vidauth>];
};

true;
