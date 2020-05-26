#!/usr/bin/perl

# Takes list of genome files as input
# Script checks for *.fasta or *.fas or *.fna extensions and replaces it with -contigs.fa
# 
# If none of these file extensions are found, it just appends -contigs.fa at 
# the end of the file name.

$genome_list=shift;
open (L,$genome_list);

while ($file = <L>)
{
chomp $file;
next if $file =~ /-contigs.fa$/;

	if ($file =~ /\.fasta|\.fas|\.fna/)
	{
	($new_name = $file) =~ s/\.fasta|\.fas|\.fna/-contigs.fa/;
	print "$file\t$new_name\n";        
	next if -e $new_name;        
	rename $file => $new_name
	}
	else
	{
	$new_name = $file."-contigs.fa";
	print "$file\t$new_name\n";	
	next if -e $new_name;
        rename $file => $new_name
	}
}
