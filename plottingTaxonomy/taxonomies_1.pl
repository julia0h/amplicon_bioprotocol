#!/usr/bin/perl -w

#perl taxonomies_1.pl all.processed.pds.wang.tax.summary | perl taxonomies_2.pl all

use strict;
use Data::Dumper;

my $file = $ARGV[0]; #this is the .tax.summary file

my %tree;

open(INF, $file);

while (my $newlin=<INF>)
 {
   chomp($newlin);
   $newlin =~ s/"//g;

   if ($newlin eq ""){next};
   if ($newlin =~ "rankID"){next};
   
   my ($taxnumber,$level,$name)=split(/\t/,$newlin);
 
	$tree{$level}=$name;

	$tree{$level}=join_parents($level,\%tree);
 
 }
 
#print Dumper(\%tree);
print_hash(%tree);

	


#####################################################
sub join_parents
 {
   my ($l,$t)=@_;
   my @lev;

   while ($l ne "")
     {
	push(@lev,$t->{$l});
	$l=~s/\.*\d+$//;
     }

   return(join(";",reverse(@lev)));
 }

#subroutine of general use; prints a hash out
sub print_hash{
  my(%hash) = @_;
  foreach my $key(sort keys %hash) {
    print "'$key'\t'$hash{$key}'\n";
  }
}

