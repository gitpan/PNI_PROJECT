package PNI::Node::perlfunc::time;

use Moose;
extends 'PNI::Node';

sub init
{
	my $self = shift;

	$self->has_output( name => 'output1' , type => 'Int' );
}

sub task
{
	my $self = shift;
	if( $self->output->{output1}->is_connected )
	{
		$self->output->{output1}->content( time );
		print $self->output->{output1}->content , "\n";
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
