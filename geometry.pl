use strict;
use warnings;

our %configuration;
our %parameters;

my $SPACING_Z=4.68;
my $SPACING_Y=5.13;
my $PLATE_GAP=0.189;
my $NUM_LAYERS=21;
my $NUM_SCINT_PER_LAYER=40;
my $ABSORBER_COLUMNS=30;

#scintillator dimensions
my $scint_dx = 300/2;
my $scint_dy = 5.13/2;
my $scint_dz = 1.97/2;

#absorber dimensions
my $absorber_dx=9.8/2;
my $absorber_dy=9.6/2;
my $absorber_dz=2.0/2;

#base plate
my $baseplate_dx=300/2;# for now, have them extend the whole width
my $baseplate_dy=1.143/2;
my $baseplate_dz=($NUM_LAYERS*2*.234+2.0)/2;# for now, have it extend the whole length

#master plate
my $masterplate_dx=300/2;# for now, have them extend the whole width
my $masterplate_dy=0.1897/2;
my $masterplate_dz=($NUM_LAYERS*2*.234+2.0)/2;# for now, have them extend the whole length

#shims
my $shim_dx=300/2; #for now, have them extend the whole length
my $shim_dy=0.635/2;
my $shim_dz=2./2;

#spacers
my $spacer_offset=.17;

my $FRONT_Z=1300;
my $BOTTOM_Y=-220;


my $dz0=($NUM_LAYERS+1)*2.34;
my $dy0= ($absorber_dy+$masterplate_dy+$shim_dy)*($NUM_SCINT_PER_LAYER+2)/2;
my $y0=$BOTTOM_Y+$dy0;
my $z0=$FRONT_Z+$dz0;

sub makeFCAL
{
    build_mother();
    build_paddles();
    build_absorbers();
}

sub build_mother
{
    my %detector = init_det();
    
    $detector{"name"}        = "fcal";
    $detector{"mother"}      = "root";
    $detector{"description"} = "FCAL Mother Volume";
    $detector{"pos"}         = "0*cm $y0*cm $z0*cm";
    $detector{"rotation"}    = "0*deg 0*deg 0*deg";
    $detector{"color"}       = "000000";
    $detector{"type"}        = "Box";
    $detector{"dimensions"}  = "150*cm $dy0*cm $dz0*cm";
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
	    my $y      = sprintf("%.3f", $BOTTOM_Y-$y0+$scint_dy + 2*$baseplate_dy + 2*$scint_dy*(($n+1)%2) + $spacer_offset+(2*$absorber_dy+2*$masterplate_dy+2*$shim_dy)*int(($n-1)/2));
	    #my $y      = sprintf("%.3f", $SPACING_Y*$n);
	    my $z      = sprintf("%.3f", $FRONT_Z-$z0+$SPACING_Z*($m-1)+$absorber_dz+$SPACING_Z/2);
	    $detector{"pos"}        = "0*cm $y*cm $z*cm";
	    $detector{"rotation"}   = "0*deg 0*deg 0*deg";
	    $detector{"color"}      = "66bbff";
	    $detector{"type"}       = "Box";
	    $detector{"dimensions"} = "$scint_dx*cm $scint_dy*cm  $scint_dz*cm";
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

sub build_absorbers
{
    for(my $m=1; $m<=$NUM_LAYERS+1; $m++)
    {
  my $lnumber     = cnumber($m-1, 10);
  for(my $n=1; $n<=$NUM_SCINT_PER_LAYER/2; $n++)
        {
          for(my $l=1; $l<=$ABSORBER_COLUMNS; $l++)
          {
      my $snumber     = cnumber($n-1, 10);
            
      my $xnumber     = cnumber($l-1, 10);
      my %detector = init_det();
      
      $detector{"name"}        = "absorber_${lnumber}_${snumber}_${xnumber}";
      $detector{"mother"}      = "fcal" ;
      $detector{"description"} = "FCAL absorber number $m $n $l";
      
      # positioning

      my $x      = sprintf(10*($l-$ABSORBER_COLUMNS/2-1/2));
      my $y      = sprintf("%.3f", $BOTTOM_Y-$y0+$absorber_dy+ 2*$baseplate_dy +  $spacer_offset+(2*$absorber_dy+2*$masterplate_dy+2*$shim_dy)*($n-1));
      #my $y      = sprintf("%.3f", $SPACING_Y*$n);
      my $z      = sprintf("%.3f", $FRONT_Z-$z0+$SPACING_Z*($m-1)+$absorber_dz);
      $detector{"pos"}        = "$x*cm $y*cm $z*cm";
      $detector{"rotation"}   = "0*deg 0*deg 0*deg";
      $detector{"color"}      = "aaaaaa";
      $detector{"type"}       = "Box";
      $detector{"dimensions"} = "$absorber_dx*cm $absorber_dy*cm  $absorber_dz*cm";
      $detector{"material"}   = "G4_Fe";
      $detector{"visible"}     = 1;
      $detector{"style"}       = 1;
      #$detector{"sensitivity"} = "fcal";
      #$detector{"hit_type"}    = "fcal";
      #$detector{"identifiers"} = "sector manual 1 layer manual $m paddle manual $n side manual 0";
      
      print_det(\%configuration, \%detector);
            
          }
  }
    }
}
