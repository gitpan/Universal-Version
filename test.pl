# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'
# $Revision: 3.0 $

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 48;
use Universal::Version;
use Devel::Peek;
ok(1); # If we made it this far, we're ok.

#########################

# Insert your test code below, the Test module is use()ed here so read
# its man page ( perldoc Test ) for help writing this test script.

# Test stringify operator
my $version = new Universal::Version "5.005";
is ( "$version" , "5.5" , '5.005 eq 5.5' );
$version = new Universal::Version "5.005_02";
is ( "$version" , "5.5.20" , '5.005_02 eq 5.5.20' );
$version = new Universal::Version "5.006.001";
is ( "$version" , "5.6.1" , '5.006.001 eq 5.6.1' );
$version = new Universal::Version "1.2.3_02";
is ( "$version" , "1.2.3.20" , '1.2.3_02 eq 1.2.3.20' );
$version = new Universal::Version "1.2_3_02";
is ( "$version" , "1.2.30.20" , '1.2_3_02 eq 1.2.30.20' );

# Test boolean operator
ok ($version, 'boolean');

# Test numify operator
ok ( $version->numify == 1.002030020, '$version->numify == 1.002030020' );

# Test comparison operators with self
print STDERR "# tests with self\n";
ok ( $version eq $version, '$version eq $version' );
is ( $version cmp $version, 0, '$version cmp $version == 0' );
ok ( $version == $version, '$version == $version' );

# test first with non-object
$version = new Universal::Version "5.006.001";
my $new_version = "5.8.0";
print STDERR "# tests with non-objects\n";
ok ( $version ne $new_version, '$version ne $new_version' );
ok ( $version lt $new_version, '$version lt $new_version' );
ok ( $new_version gt $version, '$new_version gt $version' );
$new_version = "$version";
ok ( $version eq $new_version, '$version eq $new_version' );
ok ( $new_version eq $version, '$new_version eq $version' );

# now test with existing object
$new_version = new Universal::Version "5.8.0";
print STDERR "# tests with objects\n";
ok ( $version ne $new_version, '$version ne $new_version' );
ok ( $version lt $new_version, '$version lt $new_version' );
ok ( $new_version gt $version, '$new_version gt $version' );
$new_version = new Universal::Version "$version";
ok ( $version eq $new_version, '$version eq $new_version' );

# Test Numeric Comparison operators
# test first with non-object
my $new_version = "5.8.0";
print STDERR "# numeric tests with non-objects\n";
ok ( $version == $version, '$version == $version' );
ok ( $version < $new_version, '$version < $new_version' );
ok ( $new_version > $version, '$new_version > $version' );
ok ( $version != $new_version, '$version != $new_version' );

# now test with existing object
$new_version = new Universal::Version $new_version;
print STDERR "# numeric tests with objects\n";
ok ( $version < $new_version, '$version < $new_version' );
ok ( $new_version > $version, '$new_version > $version' );
ok ( $version != $new_version, '$version != $new_version' );

# now test with actual numbers
print STDERR "# numeric tests with numbers\n";
ok ( $version->numify() == 5.006001, '$version->numify() == 5.006001' );
ok ( $version->numify() <= 5.006001, '$version->numify() <= 5.006001' );
ok ( $version->numify() < 5.008, '$version->numify() < 5.008' );
ok ( $version->numify() > 5.005_02, '$version->numify() > 5.005_02' );

# now test with Beta version form with string
$version = new Universal::Version "1.2.3";
$new_version = "1.2.3_02";
print STDERR "# tests with beta-style non-objects\n";
ok ( $version < $new_version, '$version < $new_version' );
ok ( $new_version > $version, '$new_version > $version' );
ok ( $version != $new_version, '$version != $new_version' );

$version = new Universal::Version "1.2.4";
print STDERR "# numeric tests with beta-style non-objects\n";
ok ( $version > $new_version, '$version > $new_version' );
ok ( $new_version < $version, '$new_version < $version' );
ok ( $version != $new_version, '$version != $new_version' );

# now test with Beta version form with object
$version = new Universal::Version "1.2.3";
$new_version = new Universal::Version "1.2.3_02";
print STDERR "# tests with beta-style objects\n";
ok ( $version < $new_version, '$version < $new_version' );
ok ( $new_version > $version, '$new_version > $version' );
ok ( $version != $new_version, '$version != $new_version' );

$version = new Universal::Version "1.2.4";
print STDERR "# numeric tests with beta-style objects\n";
ok ( $version > $new_version, '$version > $new_version' );
ok ( $new_version < $version, '$new_version < $version' );
ok ( $version != $new_version, '$version != $new_version' );

# that which is not expressly permitted is forbidden
print STDERR "# forbidden operations\n";
ok ( !eval { $version++ }, "noop ++" );
ok ( !eval { $version-- }, "noop --" );
ok ( !eval { $version/1 }, "noop /" );
ok ( !eval { $version*3 }, "noop *" );
ok ( !eval { abs($version) }, "noop abs" );
