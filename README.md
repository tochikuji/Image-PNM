# NAME

Image::PNM - Interface for PNM format image file

# SYNOPSIS

    use Image::PNM;
    my $img = Image::PNM->new($filepath);
    $img->width; $img->height;
    $img->getpixel(1, 2);
    $arr_ref = $img->bitmap;

# DESCRIPTION

Image::PNM is a light weight image interface for PNM formatted image file,

which is ppm, pgm, pbm;

It can only load image or save image.

But lighter than other Image libraries.

# LICENSE

Copyright (C) Aiga Suzuki.

This software is released under MIT License.

# AUTHOR

Aiga Suzuki
