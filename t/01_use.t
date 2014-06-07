use strict;
use Test::More;
use Image::PNM;

my $obj = new_ok('Image::PNM' => ['./resource/example.ppm']);
is($obj->type, 'P6', 'Is file format correct?');
is($obj->width, 640, 'width?');
is($obj->height, 400, 'height?');
is($obj->bmax, 255, 'bright max?');
is($obj->getpixel(45, 55)->[2], 249, 'getpixel?');

done_testing;
