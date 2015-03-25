#!/usr/bin/perl -w

#perl taxonomies_1.pl all.processed.pds.wang.tax.summary | perl taxonomies_2.pl all
#takes input from taxonomies_1.pl

use strict;

	my $output_file = "$ARGV[0].ref.txt";
	
	open (OUTPUT, ">$output_file");


foreach (<STDIN>) {
	chomp;
	$_ =~ s/'//g;

my @array = split (/;/, $_);

my $level = shift (@array); 

$level =~ s/\t//g;
$level =~ s/Root//g;

my $taxalevel = $level =~ tr/\.//;

my ($root, $bacteria, $phylum, $class, $order, $family, $genus, $species);
my $taxonomy;
#$print "@array\n";

if ($taxalevel == 0) {
	$root = "Root";
	$taxonomy = join(";", $root);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";
}

elsif ($taxalevel == 1) {
	$root = "Root";
	$bacteria = $array[0];
	$taxonomy = join(";", $root, $bacteria);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";
}

elsif ($taxalevel == 2) {
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-1];
	$taxonomy = join(";", $phylum);

print OUTPUT "$level\t$taxalevel\t$taxonomy\n";

}

elsif ($taxalevel == 3) {	
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-2];
	$class = $array[-1];
	$taxonomy = join(";", $phylum, $class);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";

}

elsif ($taxalevel == 4) {
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-3];
	$class = $array[-2];
	$order = $array[-1];
	$taxonomy = join(";", $phylum, $class, $order);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";

}

elsif ($taxalevel == 5) {
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-4];
	$class = $array[-3];
	$order = $array[-2];
	$family = $array[-1];
	$taxonomy = join(";", $phylum, $class, $order, $family);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";

}

elsif ($taxalevel == 6) {
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-5];
	$class = $array[-4];
	$order = $array[-3];
	$family = $array[-2];
	$genus = $array[-1];
my	$taxonomy = join(";", $phylum, $class, $order, $family, $genus);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";
}

elsif ($taxalevel == 7) {
	$root = "Root";
	$bacteria = $array[0];
	$phylum = $array[-6];
	$class = $array[-5];
	$order = $array[-4];
	$family = $array[-3];
	$genus = $array[-2];
	$species = $array[-1];
my	$taxonomy = join(";", $phylum, $class, $order, $family, $genus, $species);
print OUTPUT "$level\t$taxalevel\t$taxonomy\n";
}

}

