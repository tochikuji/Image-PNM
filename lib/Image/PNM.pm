package Image::PNM;

use 5.014;
use strict;
use warnings;

use Carp;
use POSIX qw/ceil/;
use File::Slurp;

use base 'Exporter';
our @EXPORT_OK = qw/load_pnm write_pnm/;

our $VERSION = "1.00";

sub _read;
sub _read_P1;
sub _read_P2;
sub _read_P3;
sub _read_P4;
sub _read_P5;
sub _read_P6;
sub _write_P1;
sub _write_P2;
sub _write_P3;
sub _write_P4;
sub _write_P5;
sub _write_P6;


sub new{
    my $package = shift;

    my $self = {
        bitmap => [],
    };

    return bless $self, $package;
}


sub load{
    my $self = shift;
    my $filepath = shift;

    my $header = _read($filepath);

    for(keys %$header){
        $self->{$_} = $header->{$_};
    }

    1;
}


sub write{
    my $self = shift;

    _write(@_);
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


sub _write{
    my $filepath = shift;
    my $bitmap = shift;
    my $type = shift;
    my $bmax = shift;
    my $comment = shift;

    my $height = scalar @{$bitmap};
    my $width = scalar @{$bitmap->[0]};

    $type =~ s/^P?(\d)/$1/i;

    if(defined $comment){
        $comment =~ s/^/# /mg;
    } else {
        $comment = '';
    }

    my $header;

    if($type eq '1'){
        $header = "P$type\n$comment\n$width $height\n";
        return _write_P1($bitmap, $width, $height, $header, $filepath);
    } elsif($type eq '2'){
        $header = "P$type\n$comment\n$width $height\n$bmax\n";
        return _write_P2($bitmap, $width, $height, $header, $filepath);
    } elsif($type eq '3'){
        $header = "P$type\n$comment\n$width $height\n$bmax\n";
        return _write_P3($bitmap, $width, $height, $header, $filepath);
    } elsif($type eq '4'){
        $header = "P$type\n$comment\n$width $height\n";
        return _write_P4($bitmap, $width, $height, $header, $filepath);
    } elsif($type eq '5'){
        $header = "P$type\n$comment\n$width $height\n$bmax\n";
        return _write_P5($bitmap, $width, $height, $header, $filepath);
    } elsif($type eq '6'){
        $header = "P$type\n$comment\n$width $height\n$bmax\n";
        return _write_P6($bitmap, $width, $height, $header, $filepath);
    }
}


sub _read_P1{
    my $filepath = shift;
    my $self = {};
    
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
    my $self = {};
    
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
    my $self = {};
    
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
    my $self = {};
    
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
    my $self = {};
    
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
    my $self = {};
    
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


sub _write_P1{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    
    my $str = '';

    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= ' ' unless $x == 0;
            $str .= $bitmap->[$y]->[$x];
        }
        $str .= "\n";
    }
    File::Slurp::write_file($filepath, $header . $str);

    1;
}


sub _write_P2{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    
    my $str = '';

    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= ' ' unless $x == 0;
            $str .= $bitmap->[$y]->[$x];
        }
        $str .= "\n";
    }
    File::Slurp::write_file($filepath, $header . $str);

    1;
}


sub _write_P3{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    
    my $str = '';

    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= ' ' unless $x == 0;
            $str .= join(' ', @{$bitmap->[$y]->[$x]});
        }
        $str .= "\n";
    }
    File::Slurp::write_file($filepath, $header . $str);

    1;
}


sub _write_P4{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    
    my $str = '';

    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= $bitmap->[$y]->[$x];
        }
    }
    File::Slurp::write_file($filepath, $header . pack('B*', $str));

    1;
}


sub _write_P5{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    my $str = '';
    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= chr($bitmap->[$y]->[$x]);
        }
    }

    File::Slurp::write_file($filepath, $header . $str)
        or return 0;

    1;
}


sub _write_P6{
    my ($bitmap, $width, $height, $header, $filepath) = @_;

    my $str = '';
    for my $y (0 .. $height - 1){
        for my $x (0 .. $width - 1){
            $str .= pack('C*', @{$bitmap->[$y]->[$x]});
        }
    }

    File::Slurp::write_file($filepath, $header . $str)
        or return 0;

    1;
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


# Exported methods
sub load_pnm{
    my $filepath = shift;
    my $header = _read($filepath);

    return $header->{bitmap};
}

sub write_pnm{
    _write(@_);
}


1;
__END__
