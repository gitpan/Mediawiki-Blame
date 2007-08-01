package Mediawiki::Blame::Revision;
# $Revision: 8 $
# $Date: 2007-08-01 15:01:36 +0200 (Mi, 01 Aug 2007) $
use 5.008;
use utf8;
use strict;
use warnings;
use Class::Spiffy qw(-base field);
use Perl::Version qw(); our $VERSION = Perl::Version->new('0.0.2')->stringify;

my @field_names = qw(r_id timestamp contributor text);
for my $field_name (@field_names) {
    field $field_name;
};

sub _new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->r_id(shift);
    $self->timestamp(shift);
    $self->contributor(shift);
    $self->text(shift);

    return $self;
};

1;

__END__

=head1 NAME

Mediawiki::Blame::Revision - Mediawiki revision class

=head1 VERSION

This document describes Mediawiki::Blame::Revision version 0.0.2

=head1 SYNOPSIS

    print $rev->r_id;
    print $rev->timestamp;
    print $rev->contributor;
    for (@{ $rev->text }) {
        print;
    };

=head1 DESCRIPTION

This module represents a revision on Mediawiki.

=head1 INTERFACE

=over

=item r_id

Returns the revision id associated with the revision. It is a natural number.
Later revisions have higher numbers.

=item timestamp

Returns the timestamp when the revision was made. It is in ISO 8601 format, for
instance C<2007-07-23T21:43:56Z>.

=item contributor

Returns the contributor who made the revision. This is either a Mediawiki
username or an IP address.

=item text

Returns an arrayref of lines submitted for the revision. This is the whole text
of the revision, not the difference to the previous one.

=back

=encoding utf8
