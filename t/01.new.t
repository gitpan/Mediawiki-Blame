#!perl -T
use strict;
use warnings;
use Test::More tests => 6;
use Test::Exception;

use Mediawiki::Blame qw();

dies_ok {
    Mediawiki::Blame->new
} 'naked new';

dies_ok {
    Mediawiki::Blame->new(
        'foo' => 'bar',
    );
} 'invalid new';

dies_ok {
    Mediawiki::Blame->new(
        'export' => 'http://example.org/',
    );
} 'page missing';

dies_ok {
    Mediawiki::Blame->new(
        'page' => 1,
    );
} 'export missing';

dies_ok {
    Mediawiki::Blame->new(
        'export' => 1,
    );
} 'wacky export value';

dies_ok {
    Mediawiki::Blame->new(
        'export' => 1,
        'page' => undef,
    );
} 'wacky page value';
