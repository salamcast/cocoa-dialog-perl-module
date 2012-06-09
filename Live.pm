#!/usr/bin/perl -w
#---------------------------------
#| 
#|
#| CocoaDialog Mac Live 
#|  ideal for use in a remastered/modded MacOS X Install DVD/CD
#|  can be used on a MacOS X System regular system
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

package Live;
use MacOSX::CD;
@ISA = ("MacOSX::CD");
sub new {
 my $proto = shift;
 my $class = ref($proto) || $proto;
 my $self = {};

 $self->{APP_DIR} = undef;
 $self->{APPS}    = [];

 
 bless($self, $class);
 return $self;
}
 

sub APP_DIR {
 my $self = shift;
 if (@_) { 
  $self->{APP_DIR} = shift;
  $self->APPLICATIONS();
  }
 return $self->{APP_DIR};
}

sub APPS {
 my $self = shift;
 if (@_) { @{ $self->{APPS} } = @_ }
 return @{ $self->{APPS} };
}

sub APPLICATIONS {
 my $self = shift;
  my $a = $self->{APP_DIR};
  opendir(DIR, $a);
  my @app = grep(/\.app$/,readdir(DIR)); 
  closedir(DIR);
  # declair Variables for loop
  my ($appdir,@apps, @exe, $exe, $items, $u);

  foreach my $f (@app) {
   $appdir = "$a/$f/Contents/MacOS";
   opendir(APP, $appdir);
   @exe = grep(/^[A-Za-z]/,readdir(APP));
   closedir(APP); 
   foreach $exe (@exe) 
   {
    $u = "$appdir/$exe";
    #$u =~ s/\s/|/g;
    ##will need to eventually add a check here and a counter.
    if (-x $u) {
     push(@apps,$u);
     $items = $items . "\"$exe\" ";
    }
   }
  }
  @{ $self->{APPS} } = @apps;
  $self->items($items); 
}

#List in GUI
sub guilist {
 my $self = shift;
 my ($opt, $id);
 $opt = 0;

 $self->opt('dropdown');
 my $rv = `$self->{CD} $self->{ACT} $self->{OPT}`;
 # my $o = 'dropdown';
 #    $o = $o . $self->{title} . $self->{no_newline};
 #    $o = $o . $self->{text} . $self->{items} . $self->{BUTTONS};
 # my $rv = `$self->{CD} $o`;
  ($opt,$id) = split /\n/, $rv;
  if ($opt == 1) {
   my $app = $self->{APPS}[$id];
   # comment out spaces for execution
   $app =~ s/\s/\\ /g; 
   system($app);
  } else {
   print "User canceled\n";
  }
 
}


1;
