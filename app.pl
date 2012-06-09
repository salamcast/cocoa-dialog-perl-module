#!/usr/bin/perl -w
####
use lib ".";
use Live;
my $app_dir = '/Applications/Utilities';
my $apps = Live->new();
$apps->CD();
$apps->APP_DIR($app_dir);
#$apps->APPLICATIONS();
$apps->button_list('Open', 'Exit');
$apps->title("Mac OS X Tiger System Utilities");
$apps->no_newline();
$apps->text('Please Select a Utility');

$apps->guilist();

exit();
