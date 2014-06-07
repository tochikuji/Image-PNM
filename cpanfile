requires 'Exporter';
requires 'File::Slurp';
requires 'Carp';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

