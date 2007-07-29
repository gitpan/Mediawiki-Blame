#!perl -T
use strict;
use warnings;
use Test::More tests => 28;
use Test::Exception;

use Mediawiki::Blame qw();

dies_ok {
    Mediawiki::Blame->new(
        export => 'http://THIS-HOST-DOES-NOT-EXIST',
        page   => 'test',
    );
} 'invalid host';

dies_ok {
    Mediawiki::Blame->new(
        export => 'http://example.org',
        page   => 'test',
    );
} 'no XML';

dies_ok {
    Mediawiki::Blame->new(
        export => 'http://example.org/test',
        page   => 'test',
    );
} 'faulty POST response';

my $mb = Mediawiki::Blame->new(
    export => 'http://en.wikipedia.org/wiki/Special:Export',
    page   => 'Wikipedia:Sandbox',
);

ok $mb, 'new';
is $mb->ua_timeout, 30, 'default timeout';

$mb->ua_timeout(60);
is $mb->ua_timeout, 60, 'changed timeout';

dies_ok {
    $mb->fetch
} 'no params';

dies_ok {
    $mb->fetch(
        before => 'the dawn of time'
    );
} 'bad before';

dies_ok {
    $mb->fetch(
        after => 'the end of the universe'
    );
} 'bad after';

dies_ok {
    $mb->fetch(
        before => 2000,
        after => 2000,
    );
} 'both before and after';

dies_ok {
    $mb->fetch(
        before => 'now',
        limit => 'foo',
    );
} 'bad limit';

dies_ok {
    $mb->fetch(
        before => 'now',
        limit => -2,
    );
} 'another bad limit';

{
    my ($r, $d) = $mb->fetch(
        before => '2005-07-08',
    );

    is $r, 72, 'revisions in the sandbox';
    is $d, 0, 'no duplicates, 1st fetch';
};

{
    my ($r, $d) = $mb->fetch(
        before => '2005-07-08',
        limit => 20,
    );

    is $r, 20, 'revision count matches limit, 2nd fetch';
    is $d, 20, 'got some duplicates';
};

{
    my ($r, $d) = $mb->fetch(
        after => '2005-07-08',
        limit => 2,
    );

    is $r, 2, 'revision count matches limit, 3rd fetch';
    is $d, 0, 'no duplicates, 3rd fetch';
};

is scalar $mb->revisions, 72+2, 'number of fetched revisions';

dies_ok {
    $mb->blame(
        revision => 'foo',
    );
} 'bad revision param';

{
    my @lines = $mb->blame(
        revision => 18348278,
    );
    is scalar @lines, 4, 'number of blame lines';
};

{
    my @lines = $mb->blame(
        revision => 18346473,
    );
    is scalar @lines, 1, 'number of blame lines, earliest revision';
};

delete $mb->{_revisions}->{18346473};

{
    my @lines = $mb->blame(
        revision => 18346518,
    );
    is scalar @lines, 1, 'number of blame lines, early revision';
    is $lines[0]->contributor, undef, 'contributor earlier';
};

{
    my ($r, $d) = $mb->fetch(
        before => 'now',
        limit => 2,
    );

    is $r, 2, 'revision count matches limit, 4th fetch';
    is $d, 0, 'no duplicates, 4th fetch';
};

is scalar $mb->revisions, 72+2-1+2, 'number of fetched revisions';

ok $mb->blame, 'have some blame lines';
