package Image::PNM;

use 5.014;
use strict;
use warnings;
use Carp;
use POSIX qw/ceil/;

our $VERSION = "0.02";

sub _read;
sub _read_P1;
sub _read_P2;
sub _read_P3;
sub _read_P4;
sub _read_P5;
sub _read_P6;


sub new{
    my $package = shift;
    my $filepath = shift;

    Carp::croak("filename must be specified.\n")
        unless defined $filepath;

    my $header = _read($filepath);

    my $self = {
        bitmap => [],
        filepath => $filepath,
        %$header,
    };

    return bless $self, $package;
}


sub _read{
    my $filepath = shift;
    my $self;

    open FH, '<'.$filepath
        or Carp::croak("Couldn't open file $filepath\n");
    binmode FH;

    my $buf;
    read FH, $buf, 2;
    
    if($buf eq 'P1'){
        close FH;
        $self = _read_P1($filepath);
    } elsif($buf eq 'P2'){
        close FH;
        $self = _read_P2($filepath);
    } elsif($buf eq 'P3'){
        close FH;
        $self = _read_P3($filepath);
    } elsif($buf eq 'P4'){
        close FH;
        $self = _read_P4($filepath);
    } elsif($buf eq 'P5'){
        close FH;
        $self = _read_P5($filepath);
    } elsif($buf eq 'P6'){
        close FH;
        $self = _read_P6($filepath);
    } else {
        Carp::croak("unknown file type $buf");
    }
}


sub _read_P1{
    my $filepath = shift;
    
    my $self;
    my @pool;
    my $line;
    $self->{type} = 'P1';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;

        push @pool, split(/\s/, $line);
    }

    close FH;

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            $self->{bitmap}->[$j]->[$i] = shift @pool;
        }
    }

    return $self;
}


sub _read_P2{
    my $filepath = shift;
    my $self;
    
    my @pool;
    my $line;
    $self->{type} = 'P2';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)/;
        $self->{bmax} = $1;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;

        push @pool, split(/\s/, $line);
    }

    close FH;

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            $self->{bitmap}->[$j]->[$i] = shift @pool;
        }
    }

    return $self;
}


sub _read_P3{
    my $filepath = shift;
    my $self;
    
    my @pool;
    my $line;
    $self->{type} = 'P3';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)/;
        $self->{bmax} = $1;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;

        push @pool, split(/\s/, $line);
    }

    close FH;

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            $self->{bitmap}->[$j]->[$i] = [splice(@pool, 0, 3)];
        }
    }
    
    return $self;
}


sub _read_P4{
    my $filepath = shift;
    my $self;
    
    my $line;
    $self->{type} = 'P4';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    binmode FH;
    my $buf;
    read FH, $buf, ceil($self->{width} * $self->{height} / 8);
    close FH;

    my @pool = split(//, unpack('B'.($self->{width}*$self->{height}), $buf));

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            $self->{bitmap}->[$j]->[$i] = shift @pool;
        }
    }

    return $self;
}


sub _read_P5{
    my $filepath = shift;
    my $self;
    
    my $line;
    $self->{type} = 'P5';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)/;
        $self->{bmax} = $1;
        last;
    }

    binmode FH;
    my $buf;

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            read FH, $buf, 1;
            $self->{bitmap}->[$j]->[$i] = $buf;
        }
    }
    
    close FH;

    return $self;
}

sub _read_P6{
    my $filepath = shift;
    my $self;
    
    my @pool;
    my $line;
    $self->{type} = 'P6';

    open FH, '<'.$filepath;
    <FH>;   # ignore file format

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)\s+(\d+)/;
        $self->{width} = $1;
        $self->{height} = $2;
        last;
    }

    while($line = <FH>){
        next if $line =~ /^\#/;
        $line =~ /^(\d+)/;
        $self->{bmax} = $1;
        last;
    }

    binmode FH;
    my $buf;

    for(my $j = 0; $j < $self->{height};++$j){
        for(my $i = 0;$i < $self->{width};++$i){
            read FH, $buf, 3;
            my @rgb = unpack('C3', $buf);
            $self->{bitmap}->[$j]->[$i] = [@rgb];
        }
    }
    
    close FH;

    return $self;
}

sub width{
    shift->{width}
}


sub height{
    shift->{height}
}


sub type{
    shift->{type}
}


sub bitmap{
    shift->{bitmap}
}


sub bmax{
    shift->{bmax}
}


sub getpixel{
    my $self = shift;
    my ($x, $y) = @_;

    return $self->bitmap->[$y]->[$x];
}


1;
__END__
