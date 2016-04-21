package INDEX_GEN;
use warnings;
use strict;

sub INDEXGEN
{
my $indexpod = "../doc/index.pod";
open(INDEX, ">$indexpod") or die "could not open $indexpod\n";


print INDEX <<__EOF

=pod

=head1 Documentation for Chromosome 17 Database



=cut

__EOF
;
close(INDEX) or die "could not close $indexpod\n";
}


1;