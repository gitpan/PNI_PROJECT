package PNI::Pin;

use Moose;

has 'name' => ( isa => 'Str' , is => 'ro' , required => 1 );
has 'node_ref' => ( isa => 'PNI::Node' , is => 'ro' , required => 1 );
has 'is_connected' => ( isa => 'Int' , is => 'rw' , default => 0 );
has 'is_changed' => ( isa => 'Int' , is => 'rw' , default => 0 );
has 'is_enabled' => ( isa => 'Int' , is => 'rw' , default => 1 );
has 'link_ref' => ( is => 'rw' , isa => 'PNI::Link' );
has 'content' => ( is => 'rw' , isa => 'Any' );
has 'type' => ( is => 'ro' , isa => 'Str' , required => 1 );

after 'link_ref' => sub
{
	my $self = shift;
	$self->is_connected( 1 );
};

sub get_input($)
{
	my $self = shift;
	
	if( $self->is_connected )
	{
		$self->content( $self->link_ref->input_pin_ref->content ) if $self->link_ref; # pero e' sbagliato devo fare pin::input e pin::output
	}
}

sub set_output($)
{
	my $self = shift;
	
	if( $self->is_connected )
	{
		$self->link_ref->output_pin_ref->content( $self->content );
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
