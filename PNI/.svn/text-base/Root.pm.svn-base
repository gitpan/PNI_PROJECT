package PNI::Root;

use Moose;
use PNI::Branch;

my $main_loop_is_running = 0;

has 'branches' => ( is => 'rw' , isa => 'ArrayRef[PNI::Branch]' );
has 'gui' => ( is => 'rw' , isa => 'PNI::GUI' );

sub MainLoop
{
	my $self = shift;
	
	if( $main_loop_is_running )
	{
		return;
	}
	else
	{
		$main_loop_is_running = 1;
		$self->root_task;
	}
}

sub root_task
{
	my $self = shift;

	while(1)
	{
		if( defined $self->branches )
		{
			for my $branch ( @{ $self->branches } )
			{
				$branch->task;
			}
		}
		
		$self->gui->task if defined $self->gui;
	}	
}

sub add_branch($$)
{
	my $self = shift;
	my $branch = shift;

	if( defined $self->branches )
	{
		push @{ $self->branches } , $branch;
	}
	else
	{
		$self->branches( [ $branch ] );
	}
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

