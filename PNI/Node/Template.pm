package PNI::Node::Template;

use Moose;
extends 'PNI::Node';

my $foo;

sub init
{
	my $self = shift;

	$self->has_input( name => 'input1' , type => 'Str' );
	$self->has_output( name => 'output1' , type => 'Str' );
}

sub task
{
	my $self = shift;
	print '.';
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
