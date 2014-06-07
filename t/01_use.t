use strict;
use Test::More;
use Image::PNM qw/load_pnm/;

my $obj = new_ok('Image::PNM');

ok($obj->load('resource/example.ppm'));
is($obj->type, 'P6', 'Is file format correct?');
is($obj->width, 640, 'width?');
is($obj->height, 400, 'height?');
is($obj->bmax, 255, 'bright max?');
is($obj->getpixel(45, 55)->[2], 249, 'getpixel?');
is(load_pnm('resource/example.ppm')->[55]->[45]->[0], 207, 'exported?');

done_testing;
