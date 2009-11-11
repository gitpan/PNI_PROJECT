package PNI::Patch::Canvas::NodeSelector;

use Moose;

# ma non sarebbe anche questo un Canvas::Item ? forse no perchè non deve essere esportato quando si salva la patch, cioè è solo temporaneo.
# 
has 'canvas' => ( is => 'ro' , isa => 'PNI::Patch::Canvas' , required => 1 );
has 'tree' => ( is => 'rw' , isa => 'Tk::Tree' );
#SAREBBE DA TOGLIERE IL PATCH::CANVAS E LASCIARE SOLO PATCH::WINDOW ??
#

# potrei usare  *$widget*->MapWindow e *$widget*->UnmapWindow per mostrare/nascondere l' oggetto senz ricrearlo ogni volta
# dovrei però aggiungere la possibilità di fargli fare uno scanning dei nodi disponibili.
# per ora viene creato e poi distrutto ogni volta, per questo faccio che x e y sono required.
has 'x' => ( is => 'ro' , isa => 'Int' , required => 1 );
has 'y' => ( is => 'ro' , isa => 'Int' , required => 1 );

sub init
{
	my $self = shift;

	#SAREBBE DA TOGLIERE IL PATCH::CANVAS E LASCIARE SOLO PATCH::WINDOW ??
	#che senco ha mettere canvas->canvas ??? e poi mi conviene anche per bindare gli eventi alla finestra piuttosto che al canvas.
	my $node_tree = $self->canvas->canvas->Tree( -separator => '/' );
	
	#$node_tree->pack( -fill => 'both' , -expand => 1 );

	#my @node_path_list = qw( perlfunc perlfunc/time Template );
	#for my $node_path ( @node_path_list ) 
	#{
	#	my $node_type = $node_path;
	#	$node_type =~ s!/!::!g;
	#	$node_tree->add( $node_path , -text => $node_type ); 
	#}

	$node_tree->add( 'perlfunc' , -text => 'perlfunc' , -state => 'disabled' );
	$node_tree->add( 'perlfunc/time' , -text => 'time' , -state => 'normal' );
	$node_tree->add( 'Template' , -text => 'Template' , -state => 'normal' );

	$node_tree->autosetmode();

	my $node_tree_id = $self->canvas->canvas->createWindow( $self->x , $self->y , -window => $node_tree );

	$node_tree->configure( -command => sub { $self->canvas->select_node( shift , x => $self->x , y => $self->y , node_tree_id => $node_tree_id ) } );

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

