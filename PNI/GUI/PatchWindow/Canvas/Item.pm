package PNI::GUI::PatchWindow::Canvas::Item;

use Moose;

has 'canvas' => ( is => 'ro' , isa => 'Tk::Canvas' , required => 1 );
has 'tag' => ( is => 'rw' , isa => 'Str' );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

