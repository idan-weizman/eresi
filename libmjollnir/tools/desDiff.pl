#!/usr/bin/perl

# (C) 2006 Asgard Labs, thorolf a grid.einherjar.de
# BSD License
# $Id: desDiff.pl,v 1.1.1.2 2006-02-27 22:36:33 thor Exp $

# the objects should be striped libraries
# this script was 'designed' to search for differences in
# disassembly between objdump and mydisasm/libasm


if (!$ARGV[0]) {print "usage: ./desDiff.pl test.so\n";exit();}

$b = $ARGV[0];

print "[i] Checking: $b\n";
print "[x] Objdump \n";
system("objdump -d -j .text $b > $$.$b.objdump");
print "[x] Mydisasm \n";
system("./mydisasm $b .text > $$.$b.mydisasm");

open(X1, "$$.$b.mydisasm");
open(X2, "$$.$b.objdump");

print "[i] Analisis started...\n";
while($l1 = <X1>) {
 chomp($l1);
 @d1 = split("\t",$l1);
 
 $a1 = $d1[2];
 $a1 =~ s/ //g;
 x2();
 
 if ($a1 ne $a2) { 
  $tmp = "[!] opcodes: ".  $a1 . " :: " . $a2 ."\n";
  $tmp .= "[X] LIBASM: ". $l1 . "\n";
  $tmp .= "[X] OBJDUMP: ". $l2 . "\n";
  $x = $a1;
  $x =~ s/$a2//g;
  x2();
  if ($x ne $a2) {print $tmp;exit(1);}
 }

}


sub x2 {

 $l2 = <X2>;
 if (!$l2) {exit();}
 chomp($l2);
 if ($l2 !~ /^\s+/) {x2();}
 @d2 = split("\t",$l2);
 $a2 = $d2[1];
 $a2 =~ s/ //g;

}

