package PNI::GUI::PatchWindow::Canvas::Item::Node;

use Moose;

extends 'PNI::GUI::PatchWindow::Canvas::Item';

my $callback = {};

has 'node_ref' => ( 
	is => 'ro' , 
	isa => 'PNI::Node' , 
	required => 1 , 
	trigger => sub 
	{
		my( $self , $node_ref ) = @_;
		
		$self->width( 6 * length( $node_ref->type ) );
		
		$self->id->{'border'} = $self->canvas->createRectangle( 
			$self->center_x - $self->width / 2 , 
			$self->center_y + $self->height / 2, 
			$self->center_x + $self->width / 2 , 
			$self->center_y - $self->height / 2, 
		);
			
		$self->id->{label} = $self->canvas->createText( 
			$self->center_x, 
			$self->center_y, 
			-text => $self->node_ref->type
		);

		$self->canvas->bind( 
			$self->id->{$_} , 
			'<ButtonPress-1>' => [ $callback->{select_node} , $self ]
		)
		for
		qw| border label |;

		$self->canvas->bind( 
			$self->id->{$_} , 
			'<B1-Motion>' => [ $callback->{move_node} , $self ] 
		)
		for
		qw| border label |;

		# draw input pins
	
		my @input_pin = keys %{ $node_ref->input };

	
		for( my $i = 0 ; $i <= $#input_pin ; $i++ )
	
		{
			my $pin_center_x = $self->center_x - $self->width / 2 + $self->width / ( $#input_pin + 1 ) * $i;
			my $pin_center_y = $self->center_y - $self->height / 2;

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
			$self->canvas->addtag( 'name='.$self->node_ref->input->{ $input_pin[$i] }->name , 'withtag' , $self->id->{$id_key} );
		}

		# draw output pins
	
		my @output_pin = keys %{ $node_ref->output };

		for( my $i = 0 ; $i <= $#output_pin ; $i++ )
		{
			my $pin_center_x = $self->center_x - $self->width / 2 + $self->width / ( $#output_pin + 1 ) * $i;
			my $pin_center_y = $self->center_y + $self->height / 2;
		
			my $id_key = 'output'.$i;

			$self->id->{$id_key} = $self->canvas->createRectangle( 
				$pin_center_x - 2 , 
				$pin_center_y + 2 , 
				$pin_center_x + 2 , 
				$pin_center_y - 2 , 
				-fill => 'gray', 
				-activefill => 'black', 
			);

			$self->canvas->bind( 
				$self->id->{$id_key} , 
				'<ButtonPress-1>' => [ $callback->{create_link} , $self ] 
			);
	
			$self->canvas->addtag( 'output_pin' , 'withtag' , $self->id->{$id_key} );
			$self->canvas->addtag( 'type='.$node_ref->output->{ $output_pin[$i] }->type , 'withtag' , $self->id->{$id_key} );
			$self->canvas->addtag( 'name='.$node_ref->output->{ $output_pin[$i] }->name , 'withtag' , $self->id->{$id_key} );
		}	

		# add node tag to all items
	
		$self->tag( 'Node'.$self->id->{border} );
			
		$self->canvas->addtag( $self->tag , 'withtag' , $self->id->{$_} )
		for
		( keys %{ $self->{id} } );
	} 
);
has 'last_x' => ( is => 'rw' , isa => 'Int' );
has 'last_y' => ( is => 'rw' , isa => 'Int' );
has 'center_x' => ( is => 'rw' , isa => 'Int' , required => 1 );
has 'center_y' => ( is => 'rw' , isa => 'Int' , required => 1 );
has 'height' => ( is => 'ro' , isa => 'Int' , default => 20 );
has 'width' => ( is => 'rw' , isa => 'Int' );
has 'id' => ( is => 'rw' , isa => 'HashRef[Int]' , default => sub { {} } );
has 'patch_window' => ( is => 'ro' , isa => 'PNI::GUI::PatchWindow' , required => 1 );
has 'input_link_ids' => ( is => 'rw' , isa => 'ArrayRef[Int]' , lazy => 1 , default => sub { [] } );
has 'output_link_ids' => ( is => 'rw' , isa => 'ArrayRef[Int]' , lazy => 1 , default => sub { [] } );

$callback->{create_link} = sub 
{
	my( $canvas , $self ) = @_;

	my $output_pin_id = ( $canvas->find( 'withtag' , 'current' ) )[0];

	my @output_pin_tags = $canvas->gettags( $output_pin_id );

	my $pin_type = ( grep /type=.*/ , @output_pin_tags )[0];

	my $output_pin_name = ( grep /name=.*/ , @output_pin_tags )[0];
	$output_pin_name =~ s/^name=(.*)/$1/;

	my $output_node_tag = ( grep /Node.*/ , @output_pin_tags )[0];

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
	$canvas->CanvasBind( 
		'<B1-Motion>' => [ $callback->{move_unconnected_link} , $self , $link_id , $output_node_tag , $output_pin_name , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ] );
};

$callback->{move_unconnected_link} = sub 
{
	my( $canvas , $self , $link_id , $output_node_tag , $output_pin_name , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ) = @_;

	$canvas->coords( 
		$link_id , 
		$output_pin_center_x , 
		$output_pin_center_y , 
		$canvas->XEvent->x , 
		$canvas->XEvent->y 
	);

	$canvas->CanvasBind( '<ButtonRelease-1>' => [ $callback->{connect_link} , $self , $link_id , $output_node_tag , $output_pin_name , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ] );
};

$callback->{select_node} = sub 
{
	my( $canvas , $self ) = @_;

	$self->last_x( $canvas->XEvent->x );
	$self->last_y( $canvas->XEvent->y );
};

$callback->{move_node} = sub 
{
	my( $canvas , $self ) = @_;

	my $dx = $canvas->XEvent->x - $self->last_x;
	my $dy = $canvas->XEvent->y - $self->last_y;

	$canvas->move( $self->id->{$_} , $dx , $dy )
	for
	( keys %{ $self->{id} } );

	for ( @{ $self->input_link_ids } )
	{
		my( $x1 , $y1 , $x2 , $y2 ) = $canvas->coords( $_ );
		$canvas->coords( $_ , $x1 + $dx , $y1 + $dy , $x2 , $y2 ); 
	}

	for ( @{ $self->output_link_ids } )
	{
		my( $x1 , $y1 , $x2 , $y2 ) = $canvas->coords( $_ );
		$canvas->coords( $_ , $x1 , $y1 , $x2 + $dx , $y2 + $dy ); 
	}

	$self->last_x( $canvas->XEvent->x );
	$self->last_y( $canvas->XEvent->y );	
};

$callback->{connect_link} = sub
{
	my( $canvas , $self , $link_id , $output_node_tag , $output_pin_name , $output_pin_center_x , $output_pin_center_y , @compatible_input_pin_ids ) = @_;
	
	my $input_pin_id = ( $canvas->find( 'withtag' , 'current&&input_pin' ) )[0];

	if( $input_pin_id )
	{
		my @input_pin_tags = $canvas->gettags( $input_pin_id );
	
		my $pin_type = ( grep /type=.*/ , @input_pin_tags )[0];
		
		my $input_pin_name = ( grep /name=.*/ , @input_pin_tags )[0];
		$input_pin_name =~ s/^name=(.*)/$1/;

		my $input_node_tag = ( grep /Node.*/ , @input_pin_tags )[0];

		my @compatible_input_pin_ids = $canvas->find( 'withtag' , "!$self->{tag}&&input_pin&&$pin_type" );
	
		$canvas->itemconfigure( $_ , -fill => 'black' ) for @compatible_input_pin_ids;
	
		my( $x1 , $y1 , $x2 , $y2 ) = $canvas->coords( $input_pin_id );

		my $input_pin_center_x = ( $x1 + $x2 ) / 2;

		my $input_pin_center_y = ( $y1 + $y2 ) / 2;

		$self->patch_window->create_link( $input_node_tag , $output_node_tag , $link_id , $output_pin_name , $input_pin_name , $output_pin_center_x , $output_pin_center_y , $input_pin_center_x , $input_pin_center_y );
	}
	else
	{
		$canvas->itemconfigure( $_ , -fill => 'gray' ) for @compatible_input_pin_ids;
		$canvas->delete( $link_id );
	}

	$canvas->CanvasBind( '<ButtonRelease-1>' => undef );
	$canvas->CanvasBind( '<B1-Motion>' => undef );
};

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

