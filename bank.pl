use strict;
use warnings;

our %configuration;

# Variable Type is two chars.
# The first char:
#  R for raw integrated variables
#  D for dgt integrated variables
#  S for raw step by step variables
#  M for digitized multi-hit variables
#  V for voltage(time) variables
#
# The second char:
# i for integers
# d for doubles

my $bankId   = 900;
my $bankname = "fcal";

sub define_bank
{
	
	# uploading the hit definition
        insert_bank_variable(\%configuration, $bankname, "bankid", $bankId, "Di", "$bankname bank ID");
        insert_bank_variable(\%configuration, $bankname, "layer",        1, "Di", "layer number");
	insert_bank_variable(\%configuration, $bankname, "paddle",       2, "Di", "paddle number");
	insert_bank_variable(\%configuration, $bankname, "ADCL",         3, "Di", "ADC Left");
	insert_bank_variable(\%configuration, $bankname, "ADCR",         4, "Di", "ADC Right");
	insert_bank_variable(\%configuration, $bankname, "TDCL",         5, "Di", "TDC Left");
	insert_bank_variable(\%configuration, $bankname, "TDCR",         6, "Di", "TDC Right");
	insert_bank_variable(\%configuration, $bankname, "ADCLu",        7, "Di", "ADC Left Unsmeared");
	insert_bank_variable(\%configuration, $bankname, "ADCRu",        8, "Di", "ADC Right Unsmeared");
	insert_bank_variable(\%configuration, $bankname, "TDCLu",        9, "Di", "TDC Left Unsmeared");
	insert_bank_variable(\%configuration, $bankname, "TDCRu",       10, "Di", "TDC Right Unsmeared");
	insert_bank_variable(\%configuration, $bankname, "hitn",        99, "Di", "hit number");
}
