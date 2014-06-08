# NAME

Image::PNM - Interface for PNM format image file

# SYNOPSIS

    use Image::PNM;
    my $img = Image::PNM->new;
    $img->load($filepath);
    $img->width; $img->height; $img->type;
    $img->getpixel(1, 2);
    $arr_ref = $img->bitmap;
    
    # or
    use Image::PNM qw/load_pnm/;
    my $bitmap = load_pnm($filepath);   # exported
    
    # write file
    use Image::PNM qw/write_pnm/;
    ~~~ 
    # clone image
    write_pnm('clone.ppm', $img->bitmap, $img->type, $img->bmax, "Some comments here"); # if bmax is not specified, default 255, comments is optional
    write_pnm('image.pbm', $binarymap, 'P1', 'COMMENTS: in saving bitmap(P1, P4), bmax is not specified

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
