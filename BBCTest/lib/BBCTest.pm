package BBCTest;
use Dancer ':syntax';
use DateTime;
use DateTime::Format::Strptime;
use LWP::Simple ();
use XML::Simple;

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/video' => sub {
    content_type 'application/xml';
    #content_type 'text/plain';
    my $id = param('id');

    my $xml = LWP::Simple::get(uri_for("/video/auth/$id"));
    my $xml_data = XMLin($xml);

    my $dt_parser = DateTime::Format::Strptime->new({
        pattern => '%Y-%m-%dT%H:%M',
    });
    my $start = $dt_parser->parse_datetime(
        "$xml_data->{start}{date}T$xml_data->{start}{time}"
    );
    my $end = $start->clone->add({
        seconds => $xml_data->{expireafter} / 1000,
    });

    my $resp = qq[<vidauth sig="">
  <id>$id</id>
  <authid>$xml_data->{id}</authid>
  <available start="$start" end="$end"/>
</vidauth>];
};

get '/video/auth/:id' => sub {
    my $id = param('id');

    my $start = DateTime->now;
    my $start_date = $start->date;
    my $start_time = $start->strftime('%H:%M');
    # In the absence of more detail, authorise videos for
    # 1 hour...
    my $duration = 1 * 60 * 60;
    # ... in milliseconds
    $duration *= 1000;

    # In the absence of more detail, generate a random number
    # for the authorisation id
    my $auth_id = int(rand 10_000);

    return qq[<auth id="$auth_id">
<start date="$start_date" time="$start_time" />
<expireafter>$duration</expireafter>
<history href="http://localhost/video/history/$id" />
</auth>];
};


true;
