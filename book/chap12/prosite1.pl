#!/usr/bin/perl -I . -I /home/dwyer/book/chap6

use strict;
use Prosite;
use SeqReader;

my $seqFile = new SeqReader("turkey.fasta");
my $protein;
my $bigguy;
while ($protein = $seqFile->readSeq()) {
    $bigguy .= "<$protein>";
}
$seqFile->close();

my $prosite = new Prosite("prosite.dat");
while (my $motif = $prosite->readMotif()) {
    listMotifs($bigguy,$motif);
}
$prosite->close();


sub listMotifs {
    my ($protein, $motif) = @_;
    my $pattern = $$motif{PA};
    return unless $pattern;
    return if $pattern =~ /,/;   ## skip for fair comparison to protree.
    my $description = $$motif{DE};
    $description =~ s/\n//gs;   ## remove newlines
    $pattern =~ s/\n//gs;   ## remove newlines
    $pattern = lc Prosite->perlizePattern($pattern);
    while ($protein =~ /($pattern)/g) {   ## case-insensitive
	print "$description seen as $1 at position ";
	print 1+index($protein, $1);
	print "\n";
    }
}


