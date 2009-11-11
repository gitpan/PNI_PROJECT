package PNI;

use strict;
use warnings;
use Getopt::Long;

use PNI::Root;
use PNI::GUI;

my $help;

	#TODO: usa perl5.10 e l' operatore ~~ se fai degnamente parte di milan.pm :), ma come dice Giulio devi metterlo nelle specifiche o da qualche parte lo devi scrivere per avvisare l' utente ... ascolta l' esperienza !!!
	#
	
sub StartUp
{
	GetOptions( 
		'help'    => \$help,
	) or exit;

	print &usage and exit if $help;
	
	my $root = PNI::Root->new;
	
	my $gui = PNI::GUI->new( root => $root );
	$gui->init;
	
	$root->gui( $gui );
	
	$root->MainLoop;
}


sub usage
{
return qq|
--------
PNI help
--------
) fill me :(
|;
}

1
__END__

=pod

PNI : Perl Node Interface

=cut
