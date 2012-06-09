#!/usr/bin/perl -w
#---------------------------------
#| SalamCast
#|
#| MacOS X CocoaDialog -> MacOSX::CD
#|  
#+------------------------------- */

#------------------------------------------------------------------------------
#| The MIT License
#| 
#| Copyright (c) <2007> <Karl Holz>
#| 
#| Permission is hereby granted, free of charge, to any person obtaining a copy
#| of this software and associated documentation files (the "Software"), to deal
#| in the Software without restriction, including without limitation the rights
#| to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#| copies of the Software, and to permit persons to whom the Software is
#| furnished to do so, subject to the following conditions:
#| 
#| The above copyright notice and this permission notice shall be included in
#| all copies or substantial portions of the Software.
#| 
#| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#| AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#| | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#| | OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#| THE SOFTWARE.
#+------------------------------------------------------------------------------*/
package MacOSX::CD;

use strict;

sub new {
 my $proto = shift;
 my $class = ref($proto) || $proto;
 my $self = {};
 
 
 bless($self, $class);
 return $self;
}

sub CD {
 my $self = shift;
 #Path to CocoaDialog
 $self->{PATH}     = [ '/Applications', "$ENV{HOME}/Applications"];
 # CocoaDialog Options
 $self->{OPT}      = undef;
 # CocoaDialog gui type => fileselect, filesave, input-box, textbox, etc
 $self->{ACT}      = undef;
 # Global options
 $self->{debug}      = undef; 
 $self->{title}      = undef;
 $self->{width}      = undef;
 $self->{height}     = undef;
 $self->{string_out} = undef;
 $self->{no_newline} = undef;
 
 # Common options, not all commands support them; may be ignored by class
 $self->{timeout}  = undef;
 $self->{float}    = undef;
 $self->{text}     = undef;
 $self->{BUTTONS}  = undef; #Used for all 3 buttions

 # Dropdown box
 $self->{items}         = undef;
 $self->{exit_onchange} = undef;
 $self->{pulldown}      = undef;
 
 # Input\Text\msg box common
 $self->{informative_text} = undef;
 
 # Input Box
 $self->{no_show} = undef;
 
 # Textbox
 $self->{editable}       = undef;
 $self->{focus_textbox}  = undef;
 $self->{text_from_file} = undef;
 $self->{scroll_to}      = undef;
 $self->{selected}       = undef;
 
 #Msg box
 $self->{no_cancel} = undef;
 $self->{icon_file} = undef;
 $self->{icon}      = undef;
 
 # File
 $self->{with_directory}          = undef;
 $self->{with_file}               = undef;
 $self->{packages_as_directories} = undef;
 $self->{with_extensions}         = undef;
 
 # File Select
 $self->{select_only_directories} = undef;
 $self->{select_multiple}         = undef;
 $self->{select_directories}      = undef;
 
 # File Save
 $self->{no_create_directories} = undef;
 
 # Progressbar
 $self->{percent}       = undef;
 $self->{indeterminate} = undef;
 
 # Bubble
 $self->{text_colors}        = undef;
 $self->{background_top}     = undef;
 $self->{icons}              = undef;
 $self->{independent}        = undef;
 $self->{no_timeout}         = undef;
 $self->{border_color}       = undef;
 $self->{border_colors}      = undef;
 $self->{background_bottom}  = undef;
 $self->{titles}             = undef;
 $self->{texts}              = undef;
 $self->{background_tops}    = undef;
 $self->{background_bottoms} = undef;
 $self->{alpha}              = undef;
 $self->{text_color}         = undef;
 $self->{icon_files}         = undef;
 $self->{x_placement}        = undef;
 $self->{y_placement}        = undef;

 my $CD;
 #CocoaDialog 
 for my $path ( @{ $self->{PATH} }) {
  if (-d "$path/CocoaDialog.app") {
   $CD = "$path/CocoaDialog.app/Contents/MacOS/CocoaDialog";
   last;
  }
 }
 unless (defined $CD) {
  die "Could not find CocoaDialog.app";
 }
 $self->{CD} = $CD;
}

sub opt {
 use Switch;
 #Carbon Dialog Options
 my $self = shift;
 my $o = shift;
 my $opt = ''; 
 
 # title
 if (! $self->{title})  {   $self->title() }
 $opt = $opt . ' ' . $self->{title};
 # title
 if ($self->{text})  { $opt = $opt . ' ' . $self->{text} }
 # informative_text
 if (! $self->{informative_text}) { $self->informative_text() }
 $opt = $opt . ' ' . $self->{informative_text};
 
 if ($o) {
  # String Output
  if ($self->{string_output}) { $opt = $opt . ' ' . $self->{string_output} } 
  # No Newline
  if ($self->{no_newline}) { $opt = $opt . ' ' . $self->{no_newline}    }
  # width
  if ($self->{width}) { $opt = $opt . ' ' . $self->{width}         }
  # height
  if ($self->{height}) { $opt = $opt . ' ' . $self->{height}        }
  # debug
  if ($self->{debug}) { $opt = $opt . ' ' . $self->{debug}         }
  # float 
  if ($self->{float}) { $opt = $opt . ' ' . $self->{float}         }
  # buttions
  if ($o =~ /^msgbox/ || $o =~ /dropdown$/ || $o eq 'textbox' || $o =~ /inputbox$/)
   { if ($self->{BUTTONS}) { $opt = $opt . ' ' . $self->{BUTTONS}}}
  }
# File select and file save  
  if ($o =~ /^file/) 
  {
   if ($self->{with_file}) { $opt = $opt . ' ' . $self->{with_file}}
   if ($self->{select_multiple}) { $opt = $opt . ' ' . $self->{select_multiple}}
   if ($self->{packages_as_directories}) { $opt = $opt . ' ' . $self->{packages_as_directories}}
   if ($self->{with_extensions}) { $opt = $opt . ' ' . $self->{with_extensions}}
   if ($self->{with_directory}) { $opt = $opt . ' ' . $self->{with_directory}}
   if ($self->{select_directories}) { $opt = $opt . ' ' . $self->{select_directories}}
   if ($o eq 'fileselect') 
   { 
     if ($self->{select_only_directories}) { $opt = $opt . ' ' . $self->{select_only_directories}}  
     if ($self->{no_select_directories}) { $opt = $opt . ' ' . $self->{no_select_directories}}
   }
   elsif ($o eq 'filesave') 
    { if ($self->{no_create_directories}) { $opt = $opt . ' ' . $self->{no_create_directories}}} 
  }
# progress bar  
  if ($o eq 'progressbar')
  {
   if ($self->{percent}) { $opt = $opt . ' ' . $self->{percent}} 
   if ($self->{indeterminate}) { $opt = $opt . ' ' . $self->{indeterminate}}
  }
# inputbox, no show  
  if ($o =~ /inputbox$/) { if ($self->{no_show}) { $opt = $opt . ' ' . $self->{no_show}}}
# textbox
  if ($o eq 'textbox') 
  { 
    if ($self->{editable}) { $opt = $opt . ' ' . $self->{editable}       } 
    if ($self->{focus_textbox}) { $opt = $opt . ' ' . $self->{focus_textbox}  }
    if ($self->{text_from_file}) { $opt = $opt . ' ' . $self->{text_from_file} } 
    if ($self->{scroll_to}) { $opt = $opt . ' ' . $self->{scroll_to}      }
    if ($self->{selected}) { $opt = $opt . ' ' . $self->{selected}       }
  }
# dropdown  
  if ($o =~/dropdown$/) 
  {
   if ($self->{items}) { $opt = $opt . ' ' . $self->{items}         }
   if ($self->{exit_onchange}) { $opt = $opt . ' ' . $self->{exit_onchange} }
   if ($self->{pulldown}) { $opt = $opt . ' ' . $self->{pulldown}      }
  }
# bubble  
  if ($o eq 'bubble')
  {
   if ($self->{text_colors}) { $opt = $opt . ' ' . $self->{text_colors}}
   if ($self->{background_top}) { $opt = $opt . ' ' . $self->{background_top}}
   if ($self->{string_output}) { $opt = $opt . ' ' . $self->{string_output}}
   if ($self->{texts}) { $opt = $opt . ' ' . $self->{texts}}
   if ($self->{independent}) { $opt = $opt . ' ' . $self->{independent}}
   if ($self->{border_colors}) { $opt = $opt . ' ' . $self->{border_colors}}
   if ($self->{border_color}) { $opt = $opt . ' ' . $self->{border_color}} 
   if ($self->{background_bottom}) { $opt = $opt . ' ' . $self->{background_bottom}} 
   if ($self->{titles}) { $opt = $opt . ' ' . $self->{titles}}
   if ($self->{background_tops}) { $opt = $opt . ' ' . $self->{background_tops}}
   if ($self->{alpha}) { $opt = $opt . ' ' . $self->{alpha}}
   if ($self->{background_bottoms}) { $opt = $opt . ' ' . $self->{background_bottoms}}
   if ($self->{text_color}) { $opt = $opt . ' ' . $self->{text_color}}
   if ($self->{x_placement}) { $opt = $opt . ' ' . $self->{x_placement}}
   if ($self->{y_placement}) { $opt = $opt . ' ' . $self->{y_placement}}
  }
# no cancel  
  if ($o eq 'standard-inputbox' || $o eq 'secure-standard-inputbox' || $o eq 'yesno-msgbox' || $o eq 'ok-msgbox' || $o eq 'standard-dropdown') 
   { if ($self->{no_cancel}) { $opt =  $opt . ' ' . $self->{no_cancel}}} 
# timeout  
  if    ($self->{no_timeout}) { $opt = $opt . ' ' . $self->{no_timeout} }
  elsif ($self->{timeout})    { $opt = $opt . ' ' . $self->{timeout}    }
# icon  
  if    ($self->{icon_file}) { $opt = $opt . ' ' . $self->{icon_file} }
  elsif ($self->{icon})      { $opt = $opt . ' ' . $self->{icon}      }
# Icons
  if    ($self->{icon_files}) { $opt = $opt . ' ' . $self->{icon_files} } 
  elsif ($self->{icons})      { $opt = $opt . ' ' . $self->{icons}      }
  
 
 
 $self->{OPT} = $opt;
 $self->{ACT} = $o;
 return $self->{OPT};
}

# required. These are the labels for the options provided in the dropdown box.
# list of values should be space separated, and given as multiple arguments
# (ie: don't double quote the entire list.
#  Provide it as you would multiple arguments for any shell program). 
# The first item in the list is always selected by default.
#
# Example: CocoaDialog dropdown --text "Favorite OS?" 
#            --items "GNU/Linux" "OS X" Windows Amiga "TI 89" --button1 "Ok"
sub items { # List of Items
 my $self  = shift;
 my $items = shift;
 if ($items) { $self->{items} = ' --items ' . $items }
 else { $self->{items} = ' --items "item one" "item two" "item three" ' }
 return $self->{items};
}

# If you are not getting the results you expect, try turning on this option. When there is an error,
# it will print ERROR: followed by the error message.
sub debug { # anything will set it, no unset
 my $self = shift;
 if    (! $self->{debug}) { $self->{debug} = ' --debug ' }
 else { $self->{debug} = undef  }
} 

# Sets the window's title
#  - required -. The title of the bubble.
sub title { # Text
 my $self  = shift;
 my $title = shift;
 if ($title) { $self->{title} = ' --title "' . $title . '"' }
 else { $self->{title} = ' --title "Title of you Program goes here"' }
} 

#Sets the width of the window. It's not advisable to use this option without good reason, and 
# some controls won't even respond to it. The automatic size of most windows should suffice.
sub width { # integer
 my $self = shift;
 my $w = shift;
 if ($w =~ /^\d+$/) { $self->{width} = ' --width ' . $w }
 else { $self->{width} = undef }
} 

# Sets the height of the window. It's not advisable to use this option without good reason, and 
# some controls won't even respond to it. The automatic size of most windows should suffice.
sub height { # integer
 my $self = shift;
 my $h    = shift;
 if ($h =~ /^\d+$/) { $self->{height} = ' --height ' . $h }
 else { $self->{height} = undef }
} 

#Makes yes/no/ok/cancel buttons return values as "Yes", "No", "Ok", or "Cancel" 
#instead of integers. When used with custom button labels, returns the label you provided.
sub string_output {
 my $self = shift;
 if   (! $self->{string_output})  { $self->{string_output} = ' --string-output ' }
 else { $self->{string_output} = undef }
} 

#By default, return values will be printed with a trailing newline. This will suppress that behavior.
# Note that when a control returns multiple lines this will only suppress the trailing newline on the last line.
sub no_newline {
 my $self = shift;
 if   (! $self->{no_newline})  { $self->{no_newline} = ' --no-newline ' }
 else { $self->{no_newline} = undef }
} 

# The amount of time, in seconds, that the bubble(s) will be displayed. 
# Clicking them will make them closer sooner.
# Unlike other dialogs, bubbles time out by default.
# Default value is 4.
sub timeout { #Num
 my $self = shift;
 my $num = shift;
 if   ($num =~ /^\d+$/) { $self->{timeout} = ' --timeout ' . $num }
 else { $self->{timeout} = ' --timeout 4 ' }
} 

# Float on top of all windows.
sub float {
 my $self = shift;
 if   (!  $self->{float})  { $self->{float} = ' --float ' }
 else { $self->{float} = undef }
} 

# required. The body text of the bubble.
#---------
# This is the main, bold message text. <= msgbox
sub text { # "main text message"
 my $self = shift;
 my $text = shift;
 if ($text) { $self->{text} = ' --text "' . $text . '"' }
 else { $self->{text} = ' --text "main text message"' }
} 

# - required -. A list of body texts to use in the bubbles. 
# Example: "This is bubble 1" bubble2 "and bubble 3"
#This must have the same number of items as the --titles list.
sub texts { # List of bodies for the bubbles
 my $self = shift;
 my @texts = @_;
 if (@texts) {
  my $txt;
  foreach my $t (@texts) { $txt = $txt . '"' . $t . '" ' }
  $self->{texts} = ' --texts ' . $txt;
 }
 else { $self->{texts} = ' --texts text1 "text two" text3' }
} 

sub no_cancel { # Don't show a cancel button, only "Ok".
 my $self = shift;
 if    (! $self->{no_cancel})  { $self->{no_cancel} = ' --no-cancel ' }
 else  { $self->{no_cancel} = undef }
}

# Makes the program exit immediately after the selection changes, 
# rather than waiting for the user to press one of the buttons. 
# This makes the return value for the button 4 (for both regular output and with --string-output).
sub exit_onchange {
 my $self = shift;
 if    (! $self->{exit_onchange})  { $self->{exit_onchange} = ' --exit-onchange ' }
 else  { $self->{exit_onchange} = undef }
} 

# Sets the style to a pull-down box, which differs slightly from the default pop-up style. 
# The first item remains visible.
# This option probably isn't very useful for a single-function dialog such as those CocoaDialog provides, 
# but I've included it just in case it is.
# To see how their appearances differ, just try them both.
sub pulldown {
 my $self = shift;
 if    (! $self->{pulldown})  { $self->{pulldown} = ' --pulldown ' }
 else  { $self->{pulldown} = undef }
} 

#This is the extra, smaller message text.
sub informative_text { # "extra informative text to be displayed"
 my $self = shift;
 my $infotxt = shift;
 if ($infotxt) { $self->{informative_text} = ' --informative-text "' . $infotxt . '" ' }
 else { $self->{informative_text} = ' --informative-text "Info txt goes here" ' }
} 

# This makes it a secure inputbox. Instead of what the user types, only dots will be shown.
sub no_show {
 my $self = shift;
 if    (! $self->{no_show})  { $self->{no_show} = ' --no-show ' }
 else  { $self->{no_show} = undef }
} 

# Makes the text box editable. When this option is set, 
# the return value for the button will be followed with the contents of the text box.
sub editable {
 my $self = shift;
 if    (! $self->{editable})  { $self->{editable} = ' --editable ' }
 else  { $self->{editable} = undef }
} 

# This option is only useful when --editable  is set. 
# This makes the initial focus on the textbox rather than the rightmost button.
sub focus_textbox {
 my $self = shift;
 if    (! $self->{focus_textbox})  { $self->{focus_textbox} = ' --focus-textbox ' }
 else  { $self->{focus_textbox} = undef }
} 

# Fills the text box with the contents of filename
sub text_from_file { # filename
 my $self = shift;
 my $file = shift;
 if ($file) { $self->{text_from_file} = ' --text-from-file ' . $file }
 else { $self->{text_from_file} = undef }
} 

# Where bottom_or_top is one of bottom  or top.
# Causes the text box to initially scroll to the bottom or top if the text it contains is larger than its current view.
# Default is top.
sub scroll_to { # bottom_or_top
 my $self = shift;
 my $to = shift;
 if ($to) { if ('bottom' eq $to || 'top' eq $to ) { $self->{scroll_to} = ' --scroll-to ' . $to }}
 # if it's still not set, set the default
 if (! $self->{scroll_to}) { $self->{scroll_to} = ' --scroll-to top ' }
} 

# Selects all the text in the text box.
sub selected {
 my $self = shift;
 if   (! $self->{selected}) { $self->{selected} = ' --selected ' }
 else { $self->{selected} = undef }
} 

#The full path to the custom icon image you would like to use.
# Almost every image format is accepted.
# This is incompatible with the --icon option.
sub icon_file { #"/full/path/to/icon file"
 my $self = shift;
 my $ifile = shift;
 if   ($ifile) { $self->{icon_file} = ' --icon-file ' . $ifile }
 else { $self->{icon_file} = undef }
} 

#The name of the stock icon to use. This is incompatible with --icon-file
#Default is cocoadialog
sub icon { # stockIconName
 my $self = shift;
 my $icon = shift;
 if   ($icon) { $self->{icon} = ' --icon ' . $icon }
 else { $self->{icon} = undef };
} 

# Start the file select window in directory. The default value is up to the system, 
# and will usually be the last directory visited in a file select dialog.
sub with_directory { # directory
 my $self = shift;
 my $dir = shift;
 if   ($dir) { $self->{with_directory} = ' --with-directory ' . $dir }
 else { $self->{with_directory} = undef }
} 

# Start the file select window with file  already selected.
# By default no file will be selected. This must be used with --with-directory. 
#It should be the filename of a file within the directory.
sub with_file { # file
 my $self = shift;
 my $file = shift;
 if   ($file) { $self->{with_file} = ' --with-file ' . $file }
 else { $self->{with_file} = undef }
} 

# Allows the user to navigate into packages as if they were directories, 
# rather than selecting the package as a file.
sub packages_as_dir {
 my $self = shift;
 if    (! $self->{packages_as_dir})  { $self->{packages_as_dir} = ' --packages-as-dir ' }
 else  { $self->{packages_as_dir} = undef }
} 

# fileselect:
# filesave:
#
# Limit selectable files to ones with these extensions. 
# list of extensions should be space separated, and given as multiple arguments
# (ie: don't double quote the list).
# Example: CocoaDialog fileselect --with-extensions .c .h .m .txt
# Example: CocoaDialog filesave --with-extensions .c .h .m .txt
# The period/dot at the start of each extension is optional.

sub with_extensions { # list of extensions
 my $self = shift;
 my $ext = shift;
 if ($ext) { $self->{with_extensions} = ' --with-extensions ' . $ext }
 else { $self->{with_extensions} = undef }
} 

# Allows the user to select only directories.
sub select_only_directories {
 my $self = shift;
 if    (! $self->{select_only_directories})  { $self->{select_only_directories} = ' --select-only-directories ' }
 else  { $self->{select_only_directories} = undef }
} 

# Allow the user to select more than one file.
# Default is to allow only one file/directory selection.
sub select_multiple {
 my $self = shift;
 if    (! $self->{select_multiple})  { $self->{select_multiple} = ' --select-multiple ' }
 else  { $self->{select_multiple} = undef }
} 

# Allow the user to select directories as well as files. Default is to disallow it.
sub select_directories {
 my $self = shift;
 if    (! $self->{select_directories})  { $self->{select_directories} = ' --select-directories ' }
 else  { $self->{select_directories} = undef }
} 

# Prevents the user from creating new directories.
sub no_create_directories {
 my $self = shift;
 if    (! $self->{no_create_directories})  { $self->{no_create_directories} = ' --no-create-directories ' }
 else  { $self->{no_create_directories} = undef }
} 

# Initial percentage, between 0 and 100, for the progress bar
sub percent { # number 
 my $self = shift;
 my $per = shift;
 if ($per >= 0 && $per <= 100) { $self->{percent} = ' --percent ' . $per }
 else { $self->{percent} = undef }
} 

# This option makes the progress bar an animated "barbershop pole" (for lack of better description).
# It does not indicate how far the operations you're performing have progressed; 
# it just shows that your application/script is busy. 
# You can still update the text of the label when writing to CocoaDialog's stdin 
# - and it doesn't matter what percentage you feed it.
sub indeterminate {
 my $self = shift;
 if    (! $self->{indeterminate})  { $self->{indeterminate} = ' --indeterminate '  }
 else  { $self->{indeterminate} = undef }
} 

#The color of the text on the bubble in 6 character hexadecimal format (like you use in html). 
#Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
#The default is determined by your system, but should be 000000.
sub text_colors { # list of colorHexValues
 my $self = shift;
  
 my ($y, $n) = ('', '');
 my @h = split(' ', @_);
 # check that the color number are correct
 foreach my $h (@h) {
  if ($h =~ /^[0-9a-fA-F]{6}$/) { $y = $y . ' ' . $h; } # add them into a string
  else  { $y = $y . ' 000000 '; $n = $n . ' ' . $h } # add the bad ones into a string too
 }
 if ($y) { $self->{text_colors} = ' --text-colors ' . $y }
 else { $self->{text_colors} = ' --text-colors 000000 ' }
} 

# The color of the top of the background gradient in 6 character hexadecimal format (like you use in html). 
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
# The default is B1D4F4. 
sub background_top { # colorHexValue
 my $self = shift;
 my $t = shift;
 if ($t =~ /^[0-9a-fA-F]{6}$/) { $self->{background_top} = ' --background-top ' . $t }
 else { $self->{background_top} = ' --background-top B1D4F4 ' }
} 

# The names of the stock icons to use. 
# This is incompatible with --icon-files. 
# If there are less icon names provided than there are bubbles, 
# it will use the default for the remaining.
# Defaults are cocoadialog
sub icons { # List of stock icon names
 my $self = shift;
 my $icons = join(',', @_);
 if ($icons) { $self->{icons} = ' --icons ' . $icons }
 else { $self->{icons} = undef }
} 

# This makes clicking one bubble not close the others. 
# The default behavior is to close all bubbles when you click one.
sub independent {
 my $self = shift;
 if    (! $self->{independent})  { $self->{independent} = ' --independent ' }
 else  { $self->{independent} = undef }
} 

# Don't time out. By default the bubbles will time out after 4 seconds.
# With this option enabled, they will stay visible until the user clicks them.
sub no_timeout {
 my $self = shift;
 if    (! $self->{no_timeout})  { $self->{no_timeout} = ' --no-timeout ' }
 else  { $self->{no_timeout} = undef }
} 

#The color of the border in 6 character hexadecimal format (like you use in html).
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
#The default is 808080.
sub border_color {  # colorHexValue
 my $self = shift;
 my $bcolor = shift;
 if ($bcolor =~ /^[0-9a-fA-F]{6}$/) { $self->{border_color} = ' --border-color ' . $bcolor }
 else { $self->{border_color} = ' --border-color 808080 ' }
} 

#The color of the border in 6 character hexadecimal format (like you use in html).
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
#The default is 808080.
sub border_colors { # List of hex colors
 my $self = shift;
 
 my ($y, $n) = ('', '');
 my @h = split(' ', @_);
 # check that the color number are correct
 foreach my $h (@h) {
  if ($h =~ /^[0-9a-fA-F]{6}$/) { $y = $y . ' ' . $h; } # add them into a string
  else  { $y = $y . ' 808080 '; $n = $n . ' ' . $h } # add the bad ones into a string too
 }
 if ($y) { $self->{border_colors} = ' --border-colors ' . $y }
 else { $self->{border_colors} = ' --border-colors 808080 ' }
} 

# The color of the bottom of the background gradient in 6 character hexadecimal format (like you use in html).
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
# The default is EFF7FD.
sub background_bottom {
 my $self = shift;
 my $bgbot = shift;
 if ($bgbot =~ /^[0-9a-fA-F]{6}$/) { $self->{background_bottom} = ' --background-bottom ' . $bgbot }
 else { $self->{background_bottom} = ' --background-bottom EFF7FD ' }
} 

# required. A list of titles to use in the bubbles. 
# Example: "Title for bubble 1" "And bubble2" "Bubble 3"
# This must have the same number of items as the --texts list.
sub titles { # List of titles for the bubbles
 my $self = shift;
 my $titles = join(',', @_);
 if ($titles) { $self->{titles} = ' --titles ' . $titles }
 elsif (! $self->{titles}) { $self->{titles} = ' --titles one two three '}
} 

# The color of the top of the background gradient in 6 character hexadecimal format 
# (like you use in html). 
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
# The default is B1D4F4.
sub background_tops { # List of hex colors
 my $self = shift;
 my ($y, $n) = ('', '');
 my @h = split(' ', @_);
 # check that the color number are correct
 foreach my $h (@h) {
  if ($h =~ /^[0-9a-fA-F]{6}$/) { $y = $y . ' ' . $h; } # add them into a string
  else  { $y = $y . ' B1D4F4 '; $n = $n . ' ' . $h } # add the bad ones into a string too
 }
 if ($y) { $self->{background_tops} = ' --background-tops ' . $y }
 else { $self->{background_tops} = ' --background-tops B1D4F4 ' }
} 

#The color of the bottom of the background gradient in 6 character hexadecimal format (like you use in html).
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
# The default is EFF7FD.
sub background_bottoms { # List of hex colors
 my $self = shift;
 my ($y, $n) = ('', '');
 my @h = split(' ', @_);
 # check that the color number are correct
 foreach my $h (@h) {
  if ($h =~ /^[0-9a-fA-F]{6}$/) { $y = $y . ' ' . $h; } # add them into a string
  else  { $y = $y . ' EFF7FD '; $n = $n . ' ' . $h } # add the bad ones into a string too
 }
 if ($y) { $self->{background_bottoms} = ' --background-bottoms ' . $y }
 else { $self->{background_bottoms} = ' --background-bottoms EFF7FD ' }
} 

# The alpha value (controls transparency) for the bubble(s). A number between 0 and 1.
# Default is 0.95.
sub alpha { # alphaValue
 my $self = shift;
 my $a = shift;
 if ($a =~ /^[01]\.[0-9]{2}$/) { $self->{alpha} = ' --alpha ' . $a }
 else { $self->{alpha} = ' --alpha 0.95 ' }
} 

# The color of the text on the bubble in 6 character hexadecimal format (like you use in html).
# Do not prepend a "#" to this value. Examples: "000000" for black, or "ffffff" for white.
# The default is determined by your system, but should be 000000.
sub text_color { # colorHexValue
 my $self = shift;
 my $color = shift;
 if ($color =~ /^[0-9a-fA-F]{6}$/) { $self->{text_color} = ' --text-color ' . $color }
 else { $self->{text_color} = ' --text-color 000000 '}
} 

# A list of files to use as icons. 
# This is incompatible with --icons.
# If there are less icon files provided than there are bubbles,
# it will use the default for the remaining.
# Look at the Icons section to see how to mix custom icons with stock icons.
sub icon_files { # List of full paths to icon files
 my $self = shift;
 my $ifiles = join(',', @_);
 if ($ifiles) { $self->{icon_files} = ' --icon-files ' . $ifiles }
 else { $self->{icon_files} = undef }
} 

sub x_placement { # This can be left, right, or center.
 my $self = shift;
 my $x_pos = {};
 $x_pos->{left}  = 'left';
 $x_pos->{right} = 'right';
 $x_pos->{center}= 'center';
 my $x = shift;
 if ($x_pos->{$x}) { $self->{x_placement} = ' --x-placement ' . $x }
 else { $self->{x_placement} = ' --x-placement left ' }
} 

sub y_placement { # This can be top, bottom, or center.
 my $self = shift;
 my $y_pos = {};
 $y_pos->{top}    = 'top';
 $y_pos->{bottom} = 'bottom';
 $y_pos->{center} = 'center';

 my $y = shift;
 if ($y_pos->{$y}) { $self->{y_placement} = ' --y-placement ' . $y }
 else { $self->{y_placement} = ' --y-placement top ' }
} 

########
sub button_list {
 my $self = shift;
 my ($b, $i, $n);

 if (@_) { 
  for  ($i = 0; $i <= $#_; $i++)
  {
   if ($b) { 
    $n++;
    if ($_[$i]) { $b = "$b --button$n $_[$i] " } 
    else        { $b = "$b --button$n B$n " }
   } else {
    #$n is button
    $n=1;
    if ($_[$i]) { $b = " --button$n $_[$i] " } 
    else        { $b = " --button$n B$n " }
   }
  }
  $self->{BUTTONS} = $b;
 }
 return $self->{BUTTONS};
}

sub start {
 my $self = shift;
 my $rv = `$self->{CD} $self->{ACT} $self->{OPT}`;
 return $rv;
}

sub textbox {
 my $self = shift;
 $self->editable();
 $self->scroll_to(); 
 $self->selected(); 
 if (! $self->{informative_text} ) { $self->informative_text('This is a test textbox') }
 if (! $self->{BUTTONS}) { $self->button_list('ok', 'exit') }
 if (! $self->{title} )  { $self->title('This is a test textbox title') }
 if (! $self->{text} )   { $self->text('just some test text') }
 
 # First line is the button value, the rest is the textbox
 $self->opt('textbox');
 my $rv = $self->start();
 my $textbox;
 my ($r, $t) = split /\n/, $rv, 2;
 if ($r == 1) { $textbox = $t } 
 elsif ($r == 2) { $textbox = "exit" }
 return $textbox;
}

sub progressbar {
 my $self = shift;
 use IO::File;

 ### Open a pipe to the program
 my $fh = IO::File->new("|$self->{CD} progressbar $self->{indeterminate} ");
 die "no fh" unless defined $fh;
 $fh->autoflush(1);

 if (! $self->{indeterminate})
 {
  for (my $p = 0; $p <= 100; $p++) {
   ### Update the progressbar and its label every 5%
   if (!($p % 5)) { print $fh "$p we're at $p%\n"; } 
   ### Update the progressbar every percent 
   else { print $fh "$p\n"; }
   ### simulate a long operation
   1 for (0 .. 90_000);
  }
 }
 elsif ($self->{indeterminate}) {
  for (0 .. 1_500_000) {
   ### Update the label every once and a while.
   if (!($_ % 300_000)) { 
    my @msgs = ('Still going', 'This might take a while', 'Please be patient', 'Who knows how long this will take');
    my $msg = @msgs[rand @msgs];
    ### It does not matter what percent you use on an indeterminate
    ### progressbar.  We're using 0
    print $fh "0 $msg\n";
   }
  }
  # Do your really long operation here.
 }
 else { sleep 8; }
 ### Close the filehandle to send an EOF
 $fh->close();
}

sub inputbox {
 my $self = shift; 
 $self->no_newline();
 if (!$self->{title})            { $self->title(); }
 if (!$self->{informative_text}) { $self->informative_text(); } 
 if (!$self->{BUTTONS})          { $self->button_list("Enter", "Cancel"); }
 if (!$self->{width})            { $self->width(600); }
 $self->opt('inputbox');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 my $inputbox;
 if    ($b == 1) { $inputbox = $t; } 
 elsif ($b == 2) { $inputbox = undef; }
 return $inputbox; 
}

sub standard_inputbox {
 my $self = shift; 
 $self->no_newline();
 if (!$self->{title})            { $self->title(); }
 if (!$self->{informative_text}) { $self->informative_text(); } 
 
 
 $self->opt('standard-inputbox');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 my $inputbox;
 if    ($b == 1) { $inputbox = $t; } 
 elsif ($b == 2) { $inputbox = undef; }
 return $inputbox; 
}

sub msgbox {
 my $self = shift;
 
 if ( ! $self->{text}) { $self->text(); } 
 if ( ! $self->{informative_text}) { $self->informative_text(); } 
 if ( ! $self->{BUTTONS})          { $self->button_list("Enter", "Cancel", "Quit"); }
 if ( ! $self->{string_output}) { $self->string_output() }

 $self->opt('msgbox');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 my $msgbox = $b;
 return $msgbox; 
}

sub ok_msgbox {
 my $self = shift; 
 if ( ! $self->{text}) { $self->text() } 
 if ( ! $self->{informative_text}) { $self->informative_text(); } 
 if ( ! $self->{no_newline}) { $self->no_newline() }
 if ( ! $self->{float}) { $self->float() }
 if ( ! $self->{string_output}) { $self->string_output() }

 $self->opt('ok-msgbox');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 my $msgbox = $b;
 return $msgbox; 

}

sub yesno_msgbox {
 my $self = shift; 
 if ( ! $self->{text}) { $self->text() } 
 if ( ! $self->{informative_text}) { $self->informative_text(); } 
 if ( ! $self->{no_newline}) { $self->no_newline() }
 if ( ! $self->{string_output}) { $self->string_output() }

 $self->opt('yesno-msgbox');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 my $msgbox = $b;
 return $msgbox; 

}


sub bubble {
 my $self = shift;
  # set defaults
 if (! $self->{titles} && ! $self->{title}){ $self->title() }
 if (! $self->{texts} && ! $self->{text}) { $self->text() } 
 if (! $self->{background_tops} && ! $self->{background_top}) { $self->background_top() }
 if (! $self->{backgrount_bottoms} && ! $self->{background_bottom}) { $self->background_bottom() }
 if (! $self->{border_colors} && ! $self->{border_color}) { $self->border_color() }
 if (! $self->{text_colors} && ! $self->{text_color}) { $self->text_color() }
 
 $self->opt('bubble');
 my $rv = $self->start();
 #my ($b, $t) = split /\n/, $rv, 2;
 #my $bubble = $b;
 #return $bubble; 
}

sub fileselect {
 my $self = shift;
 if (! $self->{text}) { $self->text() } 
 if (! $self->{select_multiple}) { $self->select_multiple() }
 

 $self->opt('fileselect');
 my $rv = $self->start();
 my $f = undef;
 my $dir = undef;
 foreach $f ($rv) {
  if (-e $f || -d $f) { $dir = $dir . ' ' . $f }
 }
 if ($dir) { return $dir }
}

sub dirselect {
 my $self = shift;
 if (! $self->{text}) { $self->text() } 
 if (! $self->{select_only_directories}) { $self->select_only_directories() }
 

 $self->opt('fileselect');
 my $rv = $self->start();
 $rv =~ s/^\n//;
 $rv =~ s/\n$//;
 return $rv;
}


sub dropdown {
 my $self = shift;
 if (! $self->{text}) { $self->text() } 
 
 $self->opt('dropdown');
 my $rv = $self->start();
 my ($b, $t) = split /\n/, $rv, 2;
 
}

1;
__END__
=head1 NAME

MacOSX::CD - Mac OS X Carbon Dialog

=head1 SYNOPSIS

#Usage example
use MacOSX::CD
my $CD = new MacOSX::CD;
$CD->CD();
$CD->title("This is not the Default");
$CD->text("Text from the script");
$CD->test_textbox();

=head1 REQUIRES

Perl5.8.8

=head1 EXPORTS

Nothing

=head1 DESCRIPTION

MacOSX::CD is a Object Oriented Interface to CocoaDialog to make GUIs for scripting languages like Perl.
There will be some predefined GUI's in the module, but I've designed the module to be flexible for you to create your own custom
GUIs too. The methods are the same as the switches used in the program it self, 
I wanted to keep it as similar as posible to CocoaDialog. 


=head1 METHODS

=head2 Creation

=over 4

=item new MacOSX:CD

Creates and returns a new MacOSX:CD object

=back

=head2 Settings

=over 4
=item $CD->debug()

Sets or unsets the --debug switch
 
=item $CD->title()

Sets the title with the provided string or sets the generic default title

=item $CD->width()

Sets width with an Int value or width remains undefined

=item $CD->height()

Sets height with an Int value or height remains undefined

=item $CD->string_out()

Sets string out switch with provided string or the default generic.

=item $CD->no_newline()
 
Sets or unsets the --no-newline switch

=item $CD->timeout()

Sets the timeout with an Int or sets the default of 4

=item $CD->float()

Sets or unsets the --float switch

=item $CD->text()

Sets the --text switch with the provided string or set the default generic

=item $CD->button_list()  

Used for all 3 buttion flags, can be set with an array or by sending strings.

=item $CD->items()

Set the items for a dropdown box, expects a string

=item $CD->exit_onchange()

Set or unset --exit-onchange flag

=item $CD->pulldown()
 
Set or unset --pulldown flag
 
=item $CD->informative_text()

Sets --informative-text with provided string or set a generic default value
 
=item $CD->no_show()
 
Sets or unsets --no-show switch
 
=item $CD->editable()

Sets or unsets --editable switch

=item $CD->focus_textbox()

Sets or unsets --focus-textbox switch

=item $CD->text_from_file()

Set text from provided file, or remains undefined

=item $CD->scroll_to()

Sets --scroll-to flag (top or bottom) or defaults to top

=item $CD->selected()
 
Sets or unsets --selected switch
 
=item $CD->no_cancel()

Sets or unsets --no-cancel flag

=item $CD->icon_file()

Set an icon file or remains undef, 
not compatible with --icon

=item $CD->icon()

Set an icon or remains undef, 
not compatible with --icon-file
 
=item $CD->with_directory()

Sets --with-directory flag, usally used with --with-file

=item $CD->with_file()

Sets --with-file flag, usally used with --with-directory

=item $CD->packages_as_directories()

Sets or unsets --packages-as-directories flag
 
=item $CD->with_extensions()

Sets a list of extentions, expects a string

=item $CD->select_only_directories()

Set or unsets --select-only-directories flag

=item $CD->select_multiple()

=item $CD->select_directories()
 

=item $CD->no_create_directories()
 
=item $CD->percent()

=item $CD->indeterminate()
 
=item $CD->text_colors()

Needs a Hex colour value or it sets the default

=item $CD->background_top()

Needs a Hex colour value or it sets the default

=item $CD->icons()

=item $CD->independent()

=item $CD->no_timeout()

=item $CD->border_color()

 Needs a Hex colour value or it sets the default

=item $CD->border_colors()

 Needs a Hex colour value or it sets the default

=item $CD->background_bottom()

 Needs a Hex colour value or it sets the default

=item $CD->titles()


=item $CD->texts()


=item $CD->background_tops()

 Needs a Hex colour value or it sets the default

=item $CD->background_bottoms()

 Needs a Hex colour value or it sets the default

=item $CD->alpha()


=item $CD->text_color()

 Needs a Hex colour value or it sets the default

=item $CD->icon_files()

=item $CD->x_placement()

 
=item $CD->y_placement()

=back

=head1 AUTHOR

Karl G. B. Holz, newaeon@mac.com

=cut