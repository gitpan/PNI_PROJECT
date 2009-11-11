package PNI::Patch::Canvas;

use Moose;
use PNI::Patch::Canvas::Item::Node;
use PNI::Patch::Canvas::NodeSelector;

has 'canvas'       => ( is => 'rw' , isa => 'Tk::Canvas' );
has 'patch_window' => ( is => 'rw' , isa => 'PNI::Patch::Window' , required => 1 );
has 'item' => ( is => 'rw' , isa => 'HashRef[Str]' , default => sub { {} } );

# l ideale sarebbe che il canvas gestisca solo i suoi eventi e se li smazzi verso gli altri oggetti
# ad esempio è il nodeselector che deve poi occuparsi di far selezionare i nodi
# infatti lo use PNI::Patch::Canvas::Item::Node; non ci dovrebbe essere, cioè il canvas dovrebbe astrarre
# da quali widget contiene, l' esempio piu semplice è il Item::Node e l Item::IOBox


sub init
{
	my $self = shift;

	$self->canvas->configure( 
		-confine => 0,
		-height => 400,
		-width => 600,
		-scrollregion => [ 0 , 0 , 1000 , 1000 ],
		-xscrollincrement => 1,
		-background => 'gray',
	);

	$self->canvas->pack( -expand => 1 , -fill => 'both' );

	#$self->canvas->CanvasBind( '<ButtonPress-1>' => [ \&button_press_1 ] );
	$self->canvas->CanvasBind( '<Double-Button-1>' => [ \&double_button_1 , $self ] );
}

sub double_button_1
{ 
	my( $canvas , $self ) = @_;

	$self->canvas->CanvasBind( '<ButtonPress-1>' => '' );
	$self->canvas->CanvasBind( '<Double-Button-1>' => '' );
	$self->canvas->CanvasBind( '<ButtonRelease-1>' => '' );
	$self->canvas->CanvasBind( '<B1-Motion>' => '' );

	my $node_selector =  PNI::Patch::Canvas::NodeSelector->new( canvas => $self , x => $canvas->XEvent->x , y => $canvas->XEvent->y );
	$node_selector->init();
}

sub select_node
{
	# per ora questa funzione è chiamata solamente dal NodeSelector, bisogna rivederlo più avanti.
	my $self = shift;
	my $node_path = shift;
	my $node_type = $node_path; # ho fatto qualche passaggio in piu, potrebbe essere tolto piu avanti
	$node_type =~ s!/!::!g;

	my $arg = { @_ };

	my $x = $arg->{x};
	my $y = $arg->{y};
	my $node_tree_id = $arg->{node_tree_id};
	
	my $node_ref = $self->patch_window->patch->add_node( type => $node_type );
	
	$self->create_node( center_x => $x , center_y => $y , node_ref => $node_ref );
	$self->canvas->delete( $node_tree_id );

	$self->canvas->CanvasBind( '<Double-Button-1>' => [ \&double_button_1 , $self ] );
}

sub create_node
{
	my $self = shift;
	
	my $arg = { @_ };

	my $center_x = $arg->{center_x};
	my $center_y = $arg->{center_y};
	my $node_ref = $arg->{node_ref};

	my $node = PNI::Patch::Canvas::Item::Node->new( canvas => $self->canvas , node_ref => $node_ref );

	$node->init( center_x => $center_x , center_y => $center_y , test_patch => $self->patch_window );

	$self->item->{$node->tag} = $node;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
