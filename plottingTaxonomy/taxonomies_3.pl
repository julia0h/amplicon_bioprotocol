#!/usr/bin/perl -w
use strict;

#perl taxonomies_3.pl all.ref.txt all.processed.pds.wang.tax.summary all_forR

my $ref = $ARGV[0]; #.ref.txt generated from previous step
my $file = $ARGV[1]; #cons.taxonomy file

my $name = $ARGV[2]; #desired outputname

my %reffile = &build_seq_info_hash($ref);
#print_hash(%reffile); 
#exit;

	
	my $output_file = "$name.output.txt";
	open (OUTPUT, ">$output_file");
	open (FILE, $file);
			
	foreach (<FILE>) {
	chomp;

if ($_ =~ "rankID") {
	 $_ =~ s/\s{2}/ /g;
	 $_ =~ tr/\t/ /;

	 print OUTPUT "taxon $_\n";

	 }
	 
else{
	my ($level, $rankID) = split (/\t/);

		$rankID =~ s/^\s+//;
		$rankID =~ s/\s+$//;
		$rankID =~ s/'//g;;
		$rankID =~ s/"//g;;
		
		$_ =~ tr/\t/ /;

		my $match = $reffile{$rankID} || "taxon";
	
	  print OUTPUT "$match $_\n";
}
	}




####################

sub build_seq_info_hash{
	my $file = shift;
	my %hash;

	open(IN, $file);
	foreach (<IN>) {
		chomp;
		my($rankID, $level, $taxon) = split(/\t/);
		
	$rankID =~ s/^\s+//;
	$rankID =~ s/\s+$//;
	
	$taxon =~ s/^\s+//;
	$taxon =~ s/\s+$//;
	
	$hash{$rankID} = $taxon;
	
					}
	close(IN);
	return %hash;
}

#subroutine of general use; prints a hash out
sub print_hash{
  my(%hash) = @_;
  foreach my $key(sort keys %hash) {
    print "'$key'\t'$hash{$key}'\n";
  }
}
