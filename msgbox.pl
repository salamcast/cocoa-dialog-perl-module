#!/usr/bin/perl
use MacOSX::CD;
# setup the Input script
my $title = shift;
my $txt  = shift;
my $info = shift;

my $CD = new MacOSX::CD;
$CD->CD();
$CD->float();
if ($title) { $CD->title("$title") }
if ($info)  { $CD->informative_text("$info") }
if ($txt) { $CD->text("$txt") }

# get results
my $result = $CD->msgbox();
print $result;
exit();
