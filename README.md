# NAME

Image::PNM - Interface for PNM format image file

# SYNOPSIS

    use Image::PNM;
    my $img = Image::PNM->new;
    $img->load($filepath);
    $img->width; $img->height;
    $img->getpixel(1, 2);
    $arr_ref = $img->bitmap;
    
    # or
    use Image::PNM qw/load_pnm/;
    my $bitmap = load_pnm($filepath);   # exported

# DESCRIPTION

Image::PNM is a light weight image interface for PNM formatted image file,

which is ppm, pgm, pbm;

It can only load image or save image.

But lighter than other Image libraries.

saving method has not been implemented yet.

you can only access on load or load\_pnm methods now.

# LICENSE

Copyright (C) Aiga Suzuki.

This software is released under MIT License.

# AUTHOR

Aiga Suzuki
