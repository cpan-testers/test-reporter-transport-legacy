use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }
package Test::Reporter::Transport::HTTPGateway;
# VERSION

use base 'Test::Reporter::Transport';

use LWP::UserAgent;

sub new {
  my ($class, $url, $key) = @_;

  die "invalid gateway URL: must be absolute http or https URL"
    unless $url =~ /\Ahttps?:/i;

  bless { gateway => $url, key => $key } => $class;
}

sub send {
  my ($self, $report) = @_;

  # construct the "via"
  my $report_class   = ref $report;
  my $report_version = $report->VERSION;
  my $via = "$report_class $report_version";
  $via .= ', via ' . $report->via if $report->via;
  my $perl_version = $report->perl_version->{_version};
  # post the report
  my $ua = LWP::UserAgent->new;
  $ua->timeout(60);
  $ua->env_proxy;

  my $form = {
    key     => $self->{key},
    via     => $via,
    perl_version => $perl_version,
    from    => $report->from,
    subject => $report->subject,
    report  => $report->report,
  };

  my $res = $ua->post($self->{gateway}, $form);

  return 1 if $res->is_success;

  die sprintf "HTTP error: %s: %s", $res->status_line, $res->content;
}

1;

# ABSTRACT: HTTP transport for Test::Reporter

__END__

=head1 SYNOPSIS

    my $report = Test::Reporter->new(
        transport => 'HTTPGateway',
        transport_args => [ $url, $key ],
    );

=head1 DESCRIPTION

This module transmits a Test::Reporter report via HTTP to a
L<Test::Reporter::HTTPGateway> server (or something with an equivalent API).

=head1 USAGE

See L<Test::Reporter> and L<Test::Reporter::Transport> for general usage
information.

=head2 Transport Arguments

    $report->transport_args( $url, $key );

This transport class accepts two positional arguments.  The first is required
and specifies the URL for the HTTPGateway server.  The second argument
specifies an API key to transmit to the gatway.  It is optional for the
transport class, but may be required by particular gateway servers.

=head1 METHODS

These methods are only for internal use by Test::Reporter.

=head2 new

    my $sender = Test::Reporter::Transport::HTTPGateway->new( 
        @args 
    );
    
The C<new> method is the object constructor.   

=head2 send

    $sender->send( $report );

The C<send> method transmits the report.  

=cut

