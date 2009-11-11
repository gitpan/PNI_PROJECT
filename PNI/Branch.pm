package PNI::Branch;

use Moose;

use PNI::Node;

has 'items' => ( is => 'rw' , isa => 'ArrayRef' , default => sub{[]} );
#has 'active' => ( is => 'rw' , isa => 'Bool' );

my $level;
my $hierarchy;
my $max_level = 0;

my $max = sub { $_[0]>$_[1] ? $_[0] : $_[1] };

sub add_node
{
	my $self = shift;
	my $arg = { @_ };
	
	my $node_ref = $arg->{node_ref};

	push @{ $self->items } , $node_ref;
}

sub update_hierarchy
{
	my $self = shift;
	
	# reset hierarchy
	$hierarchy = [];
	$level = {};
	
	my $num_of_items_in_hierarchy = 0;
	my $num_of_items = @{ $self->items };
	
	# prima cerco gli item al primo livello
	for my $item ( @{ $self->items } )
	{
		my @parent_items = $item->get_parents;
		
		# se non ci sono parent_items non sono a livello 1, ed esco. 
		next if @parent_items;
		
		$level->{$item} = 0;
		$hierarchy->[$level->{$item}] = [] unless defined $hierarchy->[$level->{$item}];
		push @{ $hierarchy->[$level->{$item}] } , $item;
		$num_of_items_in_hierarchy++;
	}

	while( $num_of_items_in_hierarchy < $num_of_items )
	{
		for my $item ( @{ $self->items } )
		{
			# se il nodo e' gia nella hierarchy esco dal ciclo.
			next if exists $level->{$item};
			
			my $max_parent_item_level = 0;
			
			my @parent_items = $item->get_parents;
			
			for my $parent_item ( @parent_items )
			{
				# se c'e' qualche parent che non ha un level definito non e' il momento di definire il level del figlio
				goto NEXT_ITEM unless exists $level->{$parent_item}; 
				$max_parent_item_level = &$max( $max_parent_item_level , $level->{$parent_item} );
			}
			
			$level->{$item} = $max_parent_item_level + 1;
			$hierarchy->[$level->{$item}] = [] unless defined $hierarchy->[$level->{$item}];
			push @{ $hierarchy->[$level->{$item}] } , $item;
			$num_of_items_in_hierarchy++;
			
			NEXT_ITEM:
		}
	}
}

sub task($)
{
	my $self = shift;
	
	# devo includere qui un update della hierarchy ?
	$self->update_hierarchy;
	
	for my $item_list_ref ( @{ $hierarchy } )
	{
		for my $item ( @{ $item_list_ref } )
		{
			$item->get_pin_inputs;
			$item->task;
			$item->set_pin_outputs;
		}
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
_

