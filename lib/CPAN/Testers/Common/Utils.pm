use strict;
use warnings;
package CPAN::Testers::Common::Utils;
# ABSTRACT: Utility functions for CPAN Testers modules

use Exporter ();
our @ISA = qw/Exporter/;
our @EXPORT_OK = qw(
  nntp_to_guid
  guid_to_nntp
);
our %EXPORT_TAGS = (
  all => [@EXPORT_OK]
);

#--------------------------------------------------------------------------#
# NNTP <-> GUID
#--------------------------------------------------------------------------#

# Base GUID generated with:
# Data::UUID->new->create_from_name_str(
#   NameSpace_URL, "http://nntp.x.perl.org/group/perl.cpan.testers"
# );

# Lower case is canonical
my $base_guid = "ed372d00-b19f-3f77-b713-d32bba55d77f";

sub nntp_to_guid {
  my ($nntp_id) = @_;
  my $guid = $base_guid;
  substr($guid, 0, 8, sprintf("%08d",$nntp_id)); # zero padded
  return $guid;
}

sub guid_to_nntp {
  my ($guid) = @_;
  my ($nntp_id) = $guid =~ m{\A0*([0-9]{1,7})}; # strip leading zeros
  return $nntp_id;
}

1;

__END__

=begin wikidoc

= SYNOPSIS

    use CPAN::Testers::Common::Utils ':all';

    # NNTP ID <=> GUID mapping
    $guid    = nntp_to_guid( $nntp_id );
    $nntp_id = guid_to_nntp( $guid    );

= DESCRIPTION

This module contains common utility functions for use by other CPAN Testers
modules

= USAGE

== Mapping NNTP IDs to GUIDs

Legacy CPAN Testers reports were sent via email and made available via an
NNTP group, C<perl.cpan.testers>.  Reports were 'indexed' by their NNTP ID.
The next generation of CPAN Testers uses a GUID URN to identify reports.

Old reports with an NNTP ID are mapped to GUIDs by replacing the first 8
hex characters of a common 'base GUID' with a zero-padded decimal
representation of the NNTP ID.

  XXXXXXXX-b19f-3f77-b713-d32bba55d77f

Such GUID URNs are visually distinctive and have the nice feature of
sorting earlier than second-generated report GUIDs based on a timestamp.

Two translation functions are provided for convenience.

=== {nntp_to_guid}

    $guid    = nntp_to_guid( $nntp_id );

Given a numeric NNTP ID, returns a standard string-form GUID.  (No range
checking is done.) Examples:

  nntp_to_guid( 51432   );  # 00051432-b19f-3f77-b713-d32bba55d77f
  nntp_to_guid( 6171265 );  # 06171265-b19f-3f77-b713-d32bba55d77f

=== {guid_to_nntp}

    $guid    = nntp_to_guid( $nntp_id );

Given a GUID string of the form described above, returns the decimal number
in the first 8 characaters.  (Again, there is no error checking that
the GUID is properly formatted.)  Examples:

  guid_to_nntp( '00051432-b19f-3f77-b713-d32bba55d77f' ); # 51432
  guid_to_nntp( '06171265-b19f-3f77-b713-d32bba55d77f' ); # 6171265

= BUGS

Please report any bugs or feature requests using the CPAN Request Tracker
web interface at [http://rt.cpan.org/Dist/Display.html?Queue=CPAN-Testers-Common-Utils]

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

= SEE ALSO

* Data::GUID::Any

=end wikidoc

=cut

