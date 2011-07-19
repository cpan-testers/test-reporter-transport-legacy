use strict;
BEGIN{ if (not $] < 5.006) { require warnings; warnings->import } }
package Test::Reporter::Transport::Legacy;
# VERSION

1;

# ABSTRACT: Legacy Test::Reporter::Transport modules

=head1 DESCRIPTION

This distribution contains legacy L<Test::Reporter> transport modules from
when the CPAN Testers project still accepted test report from email.  As
email submission has been discontinued, these module have been split out
from the main Test::Reporter distribution.

They are available for historical record and are not needed for CPAN Testers.
They are provided on CPAN in case someone has built a custom testing solution
using Test::Reporter and these modules and still needs them.

=cut

# vim: ts=2 sts=2 sw=2 et:
