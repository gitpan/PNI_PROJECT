package PNI::Patch::Canvas::Item::Node;

use Moose;
use PNI::Patch::Canvas::Item::Link;

extends 'PNI::Patch::Canvas::Item';

has 'node_ref' => ( is => 'rw' , isa => 'PNI::Node' , required => 1 );
has 'height' => ( is => 'ro' , isa => 'Int' , default => 20 );
has 'width' => ( is => 'rw' , isa => 'Int' );
has 'id' => ( is => 'rw' , isa => 'HashRef[Int]' , default => sub { {} } );
#has 'tag' => ( is => 'rw' , isa => 'Str' ); # TODO: mettilo nella classe Canvas::Item
has 'last_x' => ( is => 'rw' , isa => 'Int' );
has 'last_y' => ( is => 'rw' , isa => 'Int' );
has 'input_link' => ( is => 'rw' , isa => 'ArrayRef[Int]' );
has 'output_link' => ( is => 'rw' , isa => 'ArrayRef[Int]' );

# il nodo è fatto di parecchi pezzi
# una label, i vari pin, il rettangolo che racchiude tutto e anche un rettangolo sottile a destra in modo da fare la resize
#
my $center_x;
my $center_y;
#my $node_ref_tag;
#my $width;
#my $height = 20; # il primo che ho messo sotto Moose,seguiranno gli altri.

	#return unless $canvas->gettags( 'current' );
	#my $current_item_id = $canvas->find( 'withtag' , 'current' );
	#print $canvas->type( $current_item_id ) , @{ $current_item_id };
	#return unless $current_item_id; # potrei fare che se clicco sul canvas senza toccare nessun nodo lo muovo.

sub init
{
	my $self = shift;
	my $arg = { @_ };

	$center_x = $arg->{center_x};
	$center_y = $arg->{center_y};

	$self->width( 6 * length( $self->node_ref->type ) ); # la width deve dipendere dal nome del nodo per farcelo stare.

	$self->id->{border} = $self->canvas->createRectangle( 
		$center_x - $self->width / 2 , 
		$center_y + $self->height / 2, 
		$center_x + $self->width / 2 , 
		$center_y - $self->height / 2, 
	);

	# per ora come tag/id del nodo metto questo .
	$self->tag( 'NODE'.$self->id->{border} );

	$self->id->{label} = $self->canvas->createText( 
		$center_x, 
		$center_y, 
		-text => $self->node_ref->type,
	);

	$self->canvas->bind( $self->id->{$_} , '<ButtonPress-1>' => [ \&select_node , $self ] )
	for
	qw| border label |;

	$self->canvas->bind( $self->id->{$_} , '<B1-Motion>' => [ \&move_node , $self ] )
	for
	qw| border label |;

	$self->draw_input_pins;
	$self->draw_output_pins;

	$self->canvas->addtag( $self->tag , 'withtag' , $self->id->{$_} )
	for
	( keys %{ $self->{id} } );
}

sub select_node
{
	my( $canvas , $self ) = @_;

	# con disabled me lo sminchia proprio.
	#$canvas->itemconfigure( $_ , -state => 'disabled' )
	#for
	#$canvas->find( 'withtag' , 'selected' );

	# deselect previous selected items.
	#$canvas->dtag( 'selected' );

	#$canvas->addtag( 'selected' , 'withtag' , $self->id->{$_} )
	#for
	#qw| border label |;

	#$canvas->itemconfigure( $self->id->{$_} , -state => 'normal' )
	#for
	#qw| border label |;

	$self->last_x( $canvas->XEvent->x );
	$self->last_y( $canvas->XEvent->y );
	#$canvas->CanvasBind( '<B1-Motion>' => [ \&move_node , $self ] );
	#$canvas->CanvasBind( '<ButtonPress-1>' => [ \&deselect_node , $self ] );
	
}

=pod 

sub deselect_node
{
	my( $canvas , $self ) = @_;

	$canvas->itemconfigure( $self->id->{$_} , -fill => 'gray' )
	for
	qw| border label |;
	
	#$canvas->CanvasBind( '<B1-Motion>' => undef );

	#$self->canvas->bind( $self->id->{$_} , '<ButtonPress-1>' => [ \&select_node , $self ] )
	#for
	#qw| border label |;
}

=cut

sub move_node
{
	my( $canvas , $self ) = @_;

	# aggiungi il movimento del nodo , ma anche quello dei link ad esso connessi.
				
	$canvas->move( $self->id->{$_} , $canvas->XEvent->x - $self->last_x , $canvas->XEvent->y - $self->last_y )
	for
       	( keys %{ $self->{id} } );
	
	$self->last_x( $canvas->XEvent->x );
	$self->last_y( $canvas->XEvent->y );
}

sub draw_input_pins
{
	my $self = shift;
	my @input_pin = keys %{ $self->node_ref->input };

	for( my $i = 0 ; $i <= $#input_pin ; $i++ )
	{
		my $pin_center_x = $center_x - $self->width / 2 + $self->width / ( $#input_pin + 1 ) * $i;
		my $pin_center_y = $center_y - $self->height / 2;

		my $id_key = 'input'.$i;

		$self->id->{$id_key} = $self->canvas->createRectangle( 
			$pin_center_x - 2 , 
			$pin_center_y + 2 , 
			$pin_center_x + 2 , 
			$pin_center_y - 2 , 
			-fill => 'gray', 
			-activefill => 'black', 
		);

		$self->canvas->addtag( 'input_pin' , 'withtag' , $self->id->{$id_key} );
		$self->canvas->addtag( 'type='.$self->node_ref->input->{ $input_pin[$i] }->type , 'withtag' , $self->id->{$id_key} );
	}
}

sub draw_output_pins
{
	my $self = shift;
	my @output_pin = keys %{ $self->node_ref->output };

	for( my $i = 0 ; $i <= $#output_pin ; $i++ )
	{
		my $pin_center_x = $center_x - $self->width / 2 + $self->width / ( $#output_pin + 1 ) * $i;
		my $pin_center_y = $center_y + $self->height / 2;
		
		my $id_key = 'output'.$i;

		$self->id->{$id_key} = $self->canvas->createRectangle( 
			$pin_center_x - 2 , 
			$pin_center_y + 2 , 
			$pin_center_x + 2 , 
			$pin_center_y - 2 , 
			-fill => 'gray', 
			-activefill => 'black', 
		);
	
		$self->canvas->bind( $self->id->{$id_key} , '<ButtonPress-1>' => [ \&create_link , $self ] );

		$self->canvas->addtag( 'output_pin' , 'withtag' , $self->id->{$id_key} );
		$self->canvas->addtag( 'type='.$self->node_ref->output->{ $output_pin[$i] }->type , 'withtag' , $self->id->{$id_key} );
	}
}

sub create_link
{
	my( $canvas , $self ) = @_;
	
	my $output_pin_id = ( $canvas->find( 'withtag' , 'current' ) )[0];

	my @output_pin_tags = $canvas->gettags( $output_pin_id );

	my $pin_type = ( grep /type=.*/ , @output_pin_tags )[0];

	my @compatible_input_pin_ids = $canvas->find( 'withtag' , "!$self->{tag}&&input_pin&&$pin_type" );

	$canvas->itemconfigure( $_ , -fill => 'black' ) for @compatible_input_pin_ids;

	my( $x1 , $y1 , $x2 , $y2 ) = $canvas->coords( $output_pin_id );
		
	my $output_pin_center_x = ( $x1 + $x2 ) / 2;
	my $output_pin_center_y = ( $y1 + $y2 ) / 2;

	#TODO: prova a mettere a disabled i pin non compatibili, dovrebbe funzionare meglio, mettendo anche che quelli disabled spariscono.
	#
	my $link_id = $canvas->createLine( 
		$output_pin_center_x , 
		$output_pin_center_y , 
		$output_pin_center_x , 
		$output_pin_center_y 
	);

	$canvas->lower( $link_id , $output_pin_id );
		
	$canvas->CanvasBind( '<B1-Motion>' => [ \&move_unconnected_link , $self , $link_id , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ] );
}

sub move_unconnected_link
{
	my( $canvas , $self , $link_id , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ) = @_;

	$canvas->coords( 
		$link_id , 
		$output_pin_center_x , 
		$output_pin_center_y , 
		$canvas->XEvent->x , 
		$canvas->XEvent->y 
	);
		
	$canvas->CanvasBind( '<ButtonRelease-1>' => [ \&connect_link , $self , $link_id , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ] );
}

sub connect_link
{
	my( $canvas , $self , $link_id , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ) = @_;
	
	my $input_pin_id = ( $canvas->find( 'withtag' , 'current&&input_pin' ) )[0];

	
	if( $input_pin_id )
	{

		my @input_pin_tags = $canvas->gettags( $input_pin_id );

	my $pin_type = ( grep /type=.*/ , @input_pin_tags )[0];

	#my @compatible_input_pin_ids = $canvas->find( 'withtag' , "!$self->{tag}&&input_pin&&$pin_type" );

	#$canvas->itemconfigure( $_ , -fill => 'black' ) for @compatible_input_pin_ids;

	my( $x1 , $y1 , $x2 , $y2 ) = $canvas->coords( $input_pin_id );
		
	my $input_pin_center_x = ( $x1 + $x2 ) / 2;
	my $input_pin_center_y = ( $y1 + $y2 ) / 2;

		#TODO: aggiungi la parte che crea il link.
		#TODO: dovrei fare che create_node e create_link li fa il canvas? o la patch?
		my $link = PNI::Patch::Canvas::Item::Link->new( canvas => $canvas , id => $link_id , 
			start_x => $output_pin_center_x , start_y => $output_pin_center_y , end_x => $input_pin_center_x , end_y => $input_pin_center_y );

		
		#my $link_ref = PNI::Link->new;
	}
	else
	{
		$canvas->itemconfigure( $_ , -fill => 'gray' ) for @compatible_input_pin_ids;
		$canvas->delete( $link_id );
	}

	$canvas->CanvasBind( '<ButtonRelease-1>' => undef );
	$canvas->CanvasBind( '<B1-Motion>' => undef );
	
	#$self->canvas->bind( $self->id->{$_} , '<ButtonPress-1>' => [ \&select_node , $self ] )
	#for
	#qw| border label |;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

