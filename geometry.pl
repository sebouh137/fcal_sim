use strict;
use warnings;

our %configuration;
our %parameters;

my $SPACING_Z=4.68;
my $SPACING_Y=5.13;
my $PLATE_GAP=0.189;
my $NUM_LAYERS=21;
my $NUM_SCINT_PER_LAYER=20;

my $dx=300/2;
my $dy=5.13/2;
my $dz=2/2;

my $y0=-114.49;
my $z0=9.0;

sub makeFCAL
{
    build_mother();
    build_paddles();
}

sub build_mother
{
    my %detector = init_det();
    
    $detector{"name"}        = "fcal";
    $detector{"mother"}      = "root";
    $detector{"description"} = "FCAL Mother Volume";
    $detector{"pos"}         = "0*cm 0.0*cm $z0*m";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "000000";
    $detector{"type"}        = "Box";
    
    $detector{"dimensions"}  = "300*cm 200*cm 100*cm";
    $detector{"material"}    = "G4_AIR";
    $detector{"mfield"}      = "no";
    $detector{"visible"}     = 0;
    $detector{"style"}       = 0;
    print_det(\%configuration, \%detector);
}

sub build_paddles
{
    for(my $m=1; $m<=$NUM_LAYERS; $m++)
    {
	my $lnumber     = cnumber($m-1, 10);
	for(my $n=1; $n<=$NUM_SCINT_PER_LAYER; $n++)
        {
	    my $snumber     = cnumber($n-1, 10);
	    my %detector = init_det();
	    
	    $detector{"name"}        = "scint_${lnumber}_${snumber}";
	    $detector{"mother"}      = "fcal" ;
	    $detector{"description"} = "FCAL Scintillator number $m $n";
	    
	    # positioning

	    my $x      = "0";
	    my $y      = sprintf("%.3f", $y0-$dy/2.+$SPACING_Y*$n+$PLATE_GAP*int(($n-1)/2));
	    #my $y      = sprintf("%.3f", $SPACING_Y*$n);
	    my $z      = sprintf("%.3f", $SPACING_Z*$m);
	    $detector{"pos"}        = "0*cm $y*cm $z*cm";
	    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
	    $detector{"color"}      = "66bbff";
	    $detector{"type"}       = "Box";
	    $detector{"dimensions"} = "$dx*cm $dy*cm  $dz*cm";
	    $detector{"material"}   = "scintillator";
	    $detector{"visible"}     = 1;
	    $detector{"style"}       = 1;
	    $detector{"sensitivity"} = "fcal";
	    $detector{"hit_type"}    = "fcal";
	    $detector{"identifiers"} = "sector manual 1 layer manual $m paddle manual $n side manual 0";
	    
	    print_det(\%configuration, \%detector);
	}
    }
}
