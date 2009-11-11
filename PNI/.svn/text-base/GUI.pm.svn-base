package PNI::GUI;

use Moose;

use Tk;
use PNI::Patch;
use PNI::Branch;
#use PNI::Patch::Window;
use PNI::GUI::PatchWindow;

has 'responsiveness' => ( is => 'rw' , isa => 'Int' , default => 10 );
has 'root' => ( is => 'ro' , isa => 'PNI::Root' , required => 1 );
has 'main_window' => ( is => 'rw' , isa => 'Tk::MainWindow' );
has 'menubar' => ( is => 'rw' , isa => 'Tk::Menu' );

=pod

In the following code, we create a menubar, add the menubutton cascades, and hide all the menu item details in subroutines. This is simple, modular, concise, and extremely cool. 

use Tk 800.000;
use subs qw/edit_menuitems file_menuitems help_menuitems/;

my $mw = MainWindow->new;
$mw->configure(-menu => my $menubar = $mw->Menu);

my $file = $menubar->cascade(
    -label => '~File', -menuitems => file_menuitems);

my $edit = $menubar->cascade(
    -label => '~Edit', -menuitems => edit_menuitems);

my $help = $menubar->cascade(
    -label => '~Help', -menuitems => help_menuitems);
If you have lots of menubuttons, you might like this map approach, which produces an identical result. Here we feed map a code block and a list of anonymous arrays to work with. The code block prepends a tilde to the first element of each anonymous array and uses that as the menu item's -label option. The second element of each anonymous array is a subroutine call, which is invoked and returns a value for -menuitems. 

map {$menubar->cascade( -label => '~' . $_->[0], -menuitems => $_->[1] )}
    ['File', file_menuitems],
    ['Edit', edit_menuitems],
    ['Help', help_menuitems];
Regardless of how we do it, the -menuitems option is key. Obviously, its value must be a Perl scalar; in fact, -menuitems expects an array reference and, within each element of the array, yet another array reference to a list of options that describe one menu item. We thus have a list of lists. For example, here's a definition for one command menu item, with the label "Preferences ...": 

sub edit_menuitems {
    [
      ['command', 'Preferences ...'],
    ];
}


=cut

sub init
{
	my $self = shift;

	$self->main_window( new MainWindow );
	
	$self->menubar( $self->main_window->Menu( -type => 'menubar' ) );
	$self->main_window->configure( -menu => $self->menubar );
    
	
	my $file_menu = $self->menubar->cascade( -label => 'File' );
	$file_menu->command( -label => 'New' , -command => sub{ $self->new_patch_window } );
	$file_menu->command( -label => 'Open' , -command => sub{ $self->open_patch } );
	$file_menu->command( -label => 'Exit' , -command => sub{ exit } );
	
	my $help_menu = $self->menubar->cascade( -label => 'Help' );
	$help_menu->command( -label => 'Man' , -command => sub{ print "man man :)\n" } );


	$self->main_window->Label( -text => "PNI documentation \n... please write me :P")->pack;

	$self->main_window->protocol( 'WM_DELETE_WINDOW' , sub{ exit } );


	$self->new_patch_window;
}

=pod

12.3. The Win32 System Menu Item
It's possible to add menu items to the Win32 System menubutton (the button at the top-left of a Perl/Tk window, labeled with the red Tk letters in script). Based on the operating system identifier, $^O, this code conditionally adds a command menu item that executes a DOS pipeline. 

if ($^O eq 'MSWin32') {
    my $syst = $menubar->cascade(-label => '~System');
    my $dir = 'dir | sort | more';
    $syst->command(
        -label   => $dir,
        -command => sub {system $dir},
    );
}

=cut

sub task
{
	my $self = shift;
	&DoOneEvent for ( 0 .. $self->responsiveness );
	# oppure fai solo una riga cosi
	#&DoOneEvent for ( 0 .. shift->responsiveness )
}

sub open_patch
{
	my $self = shift;

	$self->new_patch_window;

	# poi il metodo dovrebbe restituirmi la nuova patch
	# qua dovrebbe prendere tutti i nodi ?
}

sub new_patch_window
{
	my $self = shift;

	my $branch = new PNI::Branch;

	$self->root->add_branch( $branch );


	my $patch_window = PNI::GUI::PatchWindow->new( 
		toplevel => $self->main_window->Toplevel , 
		patch => PNI::Patch->new( name => 'Untitled' , branch => $branch ) 
	);
#	my $patch_window = PNI::Patch::Window->new( 
#		toplevel => $self->main_window->Toplevel , 
#		patch => PNI::Patch->new( name => 'Untitled' , branch => $branch ) 
#	);

#	$patch_window->init();

}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__
