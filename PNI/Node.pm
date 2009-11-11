package PNI::Node;

use Moose;

use PNI::Pin;

sub init($){ die }; # abstract
sub task($){ die }; # abstract

has 'type'   => ( isa => 'Str' , is => 'rw' , required => 1 );
has 'input'  => ( isa => 'HashRef[Str]' , is => 'rw' , default => sub { {} } );
has 'output' => ( isa => 'HashRef[Str]' , is => 'rw' , default => sub { {} } );

# dovrei farlo che estende PNI::Branch::Item classe che dichiara la sub astratta get_parents
sub get_parents($)
{
	my $self = shift;
	my @parents = ();
	
	for my $input ( values %{ $self->input } )
	{	
		my $link_ref = $input->link_ref;
		next unless defined $link_ref;
		
		my $parent_node_ref = $link_ref->input_node_ref;
		next unless defined $parent_node_ref;
		
		push( @parents , $parent_node_ref );
	}
	return @parents;
}

sub has_input # dovrei fare che lo puo chiamare solo l init di un Node della stessa classe, oppure quanche restrizione tipo "private" in Moose
{
	my $self = shift;
	my $arg = { @_ };
	
	my $input_name = $arg->{name};
	my $input_type = $arg->{type};
	
	my $input_ref = PNI::Pin->new( name => $input_name , type => $input_type , node_ref => $self );
	$self->input->{$input_name} = $input_ref;
	
	if( my $default = $arg->{default} )
	{
		$input_ref->content( $default );
	}
}

sub has_output
{
	my $self = shift;
	my $arg = { @_ };
	
	my $output_name = $arg->{name};
	my $output_type = $arg->{type};
	
	my $output_ref = PNI::Pin->new( name => $output_name , type => $output_type , node_ref => $self );

	$self->output->{$output_name} = $output_ref;
}

sub get_pin_inputs($)
# sarebbe sub get_input_pins($)
{
	my $self = shift;
	
	for my $input_pin_ref ( values %{ $self->input } )
	{
		$input_pin_ref->get_input;
	}
}

sub set_pin_outputs($)
# sarebbe sub set_output_pins($)
{
	my $self = shift;

	for my $output_pin_ref ( values %{ $self->output } )
	{
		$output_pin_ref->set_output;
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__



