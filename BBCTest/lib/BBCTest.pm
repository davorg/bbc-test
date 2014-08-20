package BBCTest;
use Dancer ':syntax';
use DateTime;
use DateTime::Format::Strptime;
use LWP::UserAgent;
use XML::Simple;
use Digest::SHA1 'sha1_hex';
use MIME::Base64;

our $VERSION = '0.1';

set logger => 'file';

get '/' => sub {
    template 'index';
};

get '/video' => sub {
    my $id = param('id');

    my $ua = LWP::UserAgent->new;

    my $auth_resp = $ua->get(uri_for("/video/auth/$id"));

    send_error('Not found', 404)      if $auth_resp->code == 404;
    send_error('Not authorised', 403) if $auth_resp->code == 403;
    send_error('Error', 500)          if $auth_resp->is_error;

    content_type 'application/xml';

    my $xml_data = XMLin($auth_resp->content);

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

    my $sha1 = sha1_hex($resp);
    $resp =~ s/(sig=")/$1$sha1/;

    $ua->post($xml_data->{history}{href}, vidauth => $resp);

    info "Successful authorisation for video $id ($xml_data->{id})";

    if (param('fmt') // '' eq 'base64') {
        header 'content-transfer-encoding' => 'base64';
        $resp = encode_base64($resp);
    }

    return $resp;
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

    my $history_uri = uri_for("/video/history/$id");

    return qq[<auth id="$auth_id">
<start date="$start_date" time="$start_time" />
<expireafter>$duration</expireafter>
<history href="$history_uri" />
</auth>];
};

post '/video/history/:id' => sub {
    my $id = param('id');
    content_type 'text/plain';
    return 'Thank you';
};

true;
