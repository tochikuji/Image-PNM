use strict;
use Test::More;
use Image::PNM qw/load_pnm write_pnm/;

my $obj = Image::PNM->new;
ok($obj->load('resource/example.ppm'));
ok(write_pnm('resource/clone.ppm', $obj->bitmap, 'P3', $obj->bmax, "Testfile"));
is(load_pnm('resource/clone.ppm')->[135]->[98]->[1], $obj->getpixel(98, 135)->[1], 'written correctly?');
unlink('resource/clone.ppm');

done_testing;
