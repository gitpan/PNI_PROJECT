package PNI::Patch::Window;

use Moose;

use Tk;
use Tk::Tree;
use PNI::Patch::Canvas;

has 'toplevel' => ( is => 'ro' , isa => 'Tk::Toplevel' , required => 1 );
has 'canvas'   => ( is => 'rw' , isa => 'PNI::Patch::Canvas' );
has 'patch'    => ( is => 'ro' , isa => 'PNI::Patch' , required => 1 );
has 'frame'    => ( is => 'rw' , isa => 'Tk::Frame' );

#SAREBBE DA TOGLIERE IL PATCH::CANVAS E LASCIARE SOLO PATCH::WINDOW ??
sub init
{
	my $self = shift;
	
	$self->toplevel->title( $self->patch->name );
	#$self->toplevel->overrideredirect( 1 ); # no window manager decorations

	$self->frame( $self->toplevel->Frame );
	$self->frame->pack;
	

=pod

	my $hidden_menu_button = $self->frame->Menubutton( -text => 'hidden' );
	my $popup_menu = $hidden_menu_button->Menu(
		-tearoff => 0, 
		-menuitems => 
		[ 
		[qw/command ~New/], '', 
		[qw/command ~Open/], '', 
		[qw/command ~Save/], '', 
		[qw/command ~Close/], '', 
		[qw/command ~Quit/, -command => \&exit], 
		]);
	$hidden_menu_button->configure( -menu => $popup_menu );
	$self->toplevel->bind('<p>' => [sub { my($w, $x, $y) = @_; $popup_menu->post($x, $y); }, Ev('X'), Ev('Y')]);

=cut

	$self->canvas( PNI::Patch::Canvas->new( 
			canvas => $self->frame->Canvas , 
			patch_window => $self 
		) 
	);

	#$self->canvas( PNI::Patch::Canvas->new( canvas => $self->frame->Scrolled( 'Canvas' )->Subwidget( 'canvas' ) ) );
	$self->canvas->init();
}

=pod

sub node_menu
{
	my $self = shift;
	my $node_tree = $self->toplevel->Tree()->pack( -fill => 'both', -expand => 1 );

	foreach (qw/orange orange.red orange.yellow green green.blue
	       	green.yellow purple purple.red purple.blue/) {
	       	$node_tree->add($_, -text => $_);
	}

	
	$node_tree->autosetmode;
	#my $node_tree_id = $canvas->createWindow( $ev->x , $ev->y , -window => $node_tree );

	# per ora nella sub non gli passo parametri, ma mantengo lo stesso i [] per tutte le callout
	$node_tree->configure( -command => [ sub { my $node_selected = shift; $self->create_node( center_x => $ev->x , center_y => $ev->y ); $node_tree->destroy } ])
}

sub create_node
{
	my $self = shift;
	
	my $arg = { @_ };

	my $center_x = $arg->{center_x};
	my $center_y = $arg->{center_y};

	#my $node_ref .. mi serve per sapere il nome del nodo, ma in realtà non devo passarla all item, ma devo avere una lista di node_ref

	#IN REALTA dovrei fare un widget nodo e poi fare un windowCreate
	#
	my $node = PNI::Patch::Canvas::Item::Node->new( canvas => $self->canvas );

	$node->init( center_x => $center_x , center_y => $center_y );

#	return $node;
}

=cut

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

