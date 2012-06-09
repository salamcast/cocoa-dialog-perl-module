#!/usr/bin/perl
use MacOSX::CD;
# setup the textbox script
my $title = shift;
my $info = shift;
my $txt  = shift;

my $CD = new MacOSX::CD;
$CD->CD();

if ($title) { $CD->title("$title") }
if ($info)  { $CD->informative_text("$info") }
if ($txt) { $CD->text("$txt") }

# get results
my $result = $CD->textbox();
print $result;
exit();
