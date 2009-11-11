package PNI::Patch;

use Moose;

use PNI::Branch;
use PNI::Link;

has 'name'   => ( isa => 'Str' , is => 'rw' , required => 1 );
has 'path'   => ( isa => 'Str' , is => 'rw' ); # per ora è una stringa, ma dovrebbe essere qualcosa tipo File:Path
has 'branch' => ( isa => 'PNI::Branch' , is => 'rw' , required => 1 );
has 'nodes'  => ( isa => 'ArrayRef[PNI::Node]' , is => 'rw' , default => sub { [] } );
has 'links'  => ( isa => 'ArrayRef[PNI::Link]' , is => 'rw' , default => sub { [] } );

sub add_node
{
	my $self = shift;

	my $node = $self->init_node( @_ );

	$self->branch->add_node( node_ref => $node );
	
	push @{ $self->nodes } , $node;
	$self->branch->update_hierarchy;
	
	return $node;
}

sub init_node($$)
{
	my $self = shift;
	my $arg = { @_ };
	my $node_type = $arg->{type};
	
	my $node_class = "PNI::Node::$node_type";
	my $node_path = $node_class;
	$node_path =~ s!::!/!g;
	
	eval{ require $node_path . '.pm' };
	
	if($@){print $@}
	else
	{
		my $node = $node_class->new( type => $arg->{type} );
		eval{ $node->init };
		
		if($@){print $@}
		else
		{
			return $node;
		}
	}
}

sub add_link
{
	my $self = shift;
	my $arg = { @_ };
	
	my $input_node_ref = $arg->{input_node_ref}; 
	my $output_node_ref = $arg->{output_node_ref};
	my $input_pin_name = $arg->{input_pin_name};
	my $output_pin_name = $arg->{output_pin_name};
	
	my $input_pin_ref = $input_node_ref->output->{$output_pin_name};
	my $output_pin_ref = $output_node_ref->input->{$input_pin_name};
	
	my $link_ref = PNI::Link->new
	( 
		input_node_ref  => $input_node_ref ,
		input_pin_ref   => $input_pin_ref  ,
		output_node_ref => $output_node_ref,
		output_pin_ref  => $output_pin_ref
	);

	push @{ $self->links } , $link_ref;
	$input_pin_ref->link_ref( $link_ref );
	$output_pin_ref->link_ref( $link_ref );
	$self->branch->update_hierarchy;
	
	return $link_ref;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

