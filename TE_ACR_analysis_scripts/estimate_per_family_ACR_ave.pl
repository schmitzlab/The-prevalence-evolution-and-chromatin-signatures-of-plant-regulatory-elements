#!/usr/bin/perl
use strict;
use warnings;

die "usage: $0 [TE.annotation] [teACR]\n" unless @ARGV == 2;

# save total TE bp
my %te;
open F, $ARGV[0] or die;
while(<F>){
	chomp;
	my @col = split("\t",$_);
	my $dist = $col[2] - $col[1];
	if(exists $te{$col[6]}){
		$te{$col[6]} = $te{$col[6]} + $dist;
	}
	else{
		$te{$col[6]} = $dist;
	}
}
close F;

# iterate over teACRs
my %acr;
open G, $ARGV[1] or die;
while(<G>){
	chomp;
	my @col = split("\t",$_);
	$acr{$col[11]}++;
}
close G;

# normalize acr by total TE
my @keys = sort {$acr{$b} <=> $acr{$a}} keys %acr;
my @species = split(/\./, $ARGV[1]);
for (my $i = 0; $i < @keys; $i++){
	my $acrv = $acr{$keys[$i]};
	my $back = $te{$keys[$i]};
	my $norm = ($acrv/($back/1000000));
	print "$species[0]\t$keys[$i]\t$norm\t$acrv\t$back\n";
}
