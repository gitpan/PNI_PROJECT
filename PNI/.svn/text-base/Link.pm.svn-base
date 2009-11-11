package PNI::Link;

use Moose;

has 'is_connected' => ( isa => 'Int' , is => 'rw' , default => 0 ); #TODO: vedi come fare ad usarei Bool
has 'input_node_ref'  => ( isa => 'PNI::Node' , is => 'ro' , required => 1 );
has 'output_node_ref' => ( isa => 'PNI::Node' , is => 'ro' , required => 1 );
has 'input_pin_ref'  => ( isa => 'PNI::Pin' , is => 'ro' , required => 1 );
has 'output_pin_ref' => ( isa => 'PNI::Pin' , is => 'ro' , required => 1 );


1;
__END__

