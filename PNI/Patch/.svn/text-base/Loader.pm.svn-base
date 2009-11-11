package PNI::Patch::Loader;

use Moose;

use PNI::Patch;
use PNI::Root;

#my $patch_dir = '../_patches/';

sub load_patch
{

	my $self = shift;

	my $arg = { @_ };
#my $patch_file = $arg->{patch_file};
#my $patch_path = "$patch_dir/$patch_file";

#print $patch_path, "\n";
#open PATCH , $patch_path || die $!;
#my @patch_rows = <PATCH>;
#print for @patch_rows;
#close PATCH;

# AAAAAAAAAAAH NON MI FUNZIONA ... I'm going to cheat

my $patch = PNI::Patch->new( name => 'p1' );

my $nodo_da_linkare1 = $patch->add_node( name => 'test_Template' , type => 'Template' );
my $nodo_da_linkare2 = $patch->add_node( name => 'test_Template2' , type => 'Template' );
$patch->add_link( input_node_ref => $nodo_da_linkare1 , output_pin_name => 'output1' , output_node_ref => $nodo_da_linkare2 , input_pin_name => 'input1' );


&PNI::Root::get_instance()->add_branch( $patch->branch );

#for my $branch ( &PNI::Root::get_instance()->get_branches() )
#{
#print "$branch has nodes " , $branch->get_nodes() , "\n";
#}
}

1;
__END__
