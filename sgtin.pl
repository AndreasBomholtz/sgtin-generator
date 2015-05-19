#!/usr/bin/perl
use strict;
use warnings;

if(@ARGV != 5) {
	printf("Usage: $0 <filter> <partition> <company> <item> <serial>\n");
	exit
}

#Partition size array
my @partition_size = ([40,4],[37,7],[34,10],[30,14],[27,17],[24,20],[20,24]);

#Variables
my $sgtin = '';
my $hex = '';

#Parameters
my $header =    48;       #SGTIN-96
my $filter =    $ARGV[0];
my $partition = $ARGV[1];
my $company =   $ARGV[2];
my $item =      $ARGV[3];
my $serial =    $ARGV[4];

#Find company and item sizes
my $company_size = $partition_size[$partition][0];
my $item_size =    $partition_size[$partition][1];

#Generate SGTIN
printf("%-10s %8s %s %s\n","Name","Decimal","Bits","Binary");
$sgtin .= addToSgtin(('name'=>'Header',   'size'=>8,            'value'=>$header));
$sgtin .= addToSgtin(('name'=>'Filter',   'size'=>3,            'value'=>$filter));
$sgtin .= addToSgtin(('name'=>'Partition','size'=>3,            'value'=>$partition));
$sgtin .= addToSgtin(('name'=>'Company',  'size'=>$company_size,'value'=>$company));
$sgtin .= addToSgtin(('name'=>'Item Ref', 'size'=>$item_size,   'value'=>$item));
$sgtin .= addToSgtin(('name'=>'Serial',   'size'=>38,           'value'=>$serial));

#Convert binary to hex, converting a single byte each time
for( my $i=0; $i<(length $sgtin); $i+=8) {
	$hex .= sprintf('%02X', oct("0b".substr($sgtin,$i,8)));
}

#Print sgtin
printf("\n");
#printf "SGTIN (Bin): $sgtin\n";
printf "SGTIN:       $hex\n";

#Helper to print and generate values for the SGTIN
sub addToSgtin {
	my (%hash) = @_;

	my $res = sprintf("%0$hash{size}b",$hash{'value'});
	printf("%-10s %8d %4d %s\n",$hash{'name'}.":", $hash{'value'},$hash{'size'},$res);

	return $res;
}
