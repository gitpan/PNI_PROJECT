package PNI::GUI::PatchWindow;

use Moose;
use Tk;
use PNI::GUI::PatchWindow::Canvas::Item::Node;
use PNI::GUI::PatchWindow::Canvas::Item::Link;

has 'toplevel' => ( 
	is => 'ro' , 
	isa => 'Tk::Toplevel' , 
	required => 1 , 
	trigger => sub 
	{ 
		my( $self , $toplevel ) = @_;
	
		$toplevel->title( $self->patch->name );
	
		$self->frame->pack;
	
		$self->canvas( $self->frame->Canvas );
	} 
);
has 'patch' => ( is => 'ro' , isa => 'PNI::Patch' , required => 1 );
has 'frame' => ( is => 'ro' , isa => 'Tk::Frame' , lazy => 1 , default => sub { shift->toplevel->Frame } );
has 'canvas' => ( 
	#TODO: dovrei riuscire a farlo 'ro'
       	is => 'rw' , 
	isa => 'Tk::Canvas' ,
	trigger => sub {	
	    	my( $self , $canvas ) = @_;
	       	$canvas->configure( 
			-confine => 0,
			-height => 400,
	      		-width => 600,
	      		-scrollregion => [ 0 , 0 , 1000 , 1000 ],
	      		-xscrollincrement => 1,
	      		-background => 'gray',
		);
		$canvas->pack( -expand => 1 , -fill => 'both' );
		$canvas->CanvasBind( '<Double-Button-1>' => sub {
				$self->create_node( 'Template' , $canvas->XEvent->x , $canvas->XEvent->y );
		      	}
		);
	}
);
has 'node_ref' => ( is => 'rw' , isa => 'HashRef[Str]' , default => sub { {} } );
has 'item_node' => ( is => 'rw' , isa => 'HashRef[Str]' , default => sub { {} } );

sub create_node
{
	my( $self , $type , $x , $y ) = @_;

	my $node_ref = $self->patch->add_node( type => $type );
	
	my $item_node = PNI::GUI::PatchWindow::Canvas::Item::Node->new( 
		canvas => $self->canvas , 
		patch_window => $self ,
		node_ref => $node_ref ,
		center_x => $x ,
		center_y => $y
	);

	$self->node_ref->{ $item_node->tag } = $node_ref;
	$self->item_node->{ $item_node->tag } = $item_node;
}

sub create_link
{
	my( $self ,  $input_node_tag , $output_node_tag , $link_id , $output_pin_name , $input_pin_name , $output_pin_center_x , $output_pin_center_y , $input_pin_center_x , $input_pin_center_y ) = @_;

	my $input_item_node = $self->item_node->{ $input_node_tag };
	my $output_item_node = $self->item_node->{ $output_node_tag };

	push @{ $output_item_node->input_link_ids } , $link_id ;
	push @{ $input_item_node->output_link_ids } , $link_id ;

	PNI::GUI::PatchWindow::Canvas::Item::Link->new( 
		canvas => $self->canvas , 
		link_ref => $self->patch->add_link(	
			input_node_ref  => $self->node_ref->{ $input_node_tag } ,
			input_pin_name   => $input_pin_name ,
			output_node_ref => $self->node_ref->{ $output_node_tag } ,
			output_pin_name  => $output_pin_name
		) ,
		id => $link_id , 
		start_x => $output_pin_center_x , 
		start_y => $output_pin_center_y , 
		end_x => $input_pin_center_x , 
		end_y => $input_pin_center_y 
	);

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
