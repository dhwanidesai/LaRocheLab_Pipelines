#!/usr/bin/perl
use Bio::SeqIO;
use Data::Dumper;
# For a list of given Sequence ids, pull out the sequences from a Fasta file 

#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
 
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
 
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.

$USAGE = q/USAGE:
perl extract_sequences_for_OTU_ids.pl          --idfile <filename>    file containing a list of Sequence IDs for which sequences have to be extracted
					    
					       
					       --seqfile <filename>
                                               
                                               -o, --out <filename> 
                                                                       complete path to the output file where you want to store the sequences 
                       
                                     
                                                                      
                                                                      
                                                                                                                     
/;

use Getopt::Long;
use Data::Dumper;
# use Bio::SeqIO;

GetOptions (
'idfile=s' => \$idlist,
'o|out=s' => \$outfile,
'seqfile=s'   => \$seqfile,
) or die $USAGE;

die $USAGE if !$idlist or !$outfile or !$seqfile;

# $idlist=shift;
chomp $idlist;
open (ID,"$idlist");
chomp (@ids=<ID>);
@hashid{@ids}=();
#print Dumper (\%hashid);
#exit;
# $seqfile=shift;
chomp $seqfile;

# $outfile=shift;
chomp $outfile;

$in  = Bio::SeqIO->new(-file => "$seqfile" ,-format => 'Fasta');
$out  = Bio::SeqIO->new(-file => ">$outfile" ,-format => 'Fasta');

while ( my $seq = $in->next_seq() )
{
$id=$seq->display_id;
next if (!exists $hashid{$id});
$out->write_seq($seq);
#$len=$seq->length(); 
#print $seq->display_id,"\t$len\n";
}
