#!perl -T
use strict;
use warnings;
use Test::More tests => 9;
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

my $mb = Mediawiki::Blame->new(
    'export' => 'http://test.wikipedia.org/wiki/Special:Export',
    'page'   => 'Wikipedia:Sandbox',
);
ok $mb, 'new';

SKIP: {
    if (!$mb->_lwp->isa('LWPx::ParanoidAgent')) {
        skip 'only LWP::UserAgent is available', 2;
    };

    eval q{
        use Test::Without::Module qw('LWPx::ParanoidAgent');
    };

    my $mb2 = Mediawiki::Blame->new(
        'export' => 'http://test.wikipedia.org/wiki/Special:Export',
        'page'   => 'Wikipedia:Sandbox',
    );
    ok $mb2, 'new again';
    isa_ok $mb2->_lwp, 'LWP::UserAgent';
};
