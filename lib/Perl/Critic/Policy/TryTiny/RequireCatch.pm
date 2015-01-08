use strict;
use warnings;
use utf8;
package Perl::Critic::Policy::TryTiny::RequireCatch;
# ABSTRACT: Always include a "catch" block when using "try"
$Perl::Critic::Policy::TryTiny::RequireCatch::VERSION = '0.001';
use Readonly;
use Perl::Critic::Utils qw( :severities :classification :ppi );

use base 'Perl::Critic::Policy';

Readonly::Scalar my $DESC => "Try::Tiny \"try\" invoked without a corresponding \"catch\" block";
Readonly::Scalar my $EXPL => "Try::Tiny's \"try\" without a \"catch\" block will swallow exceptions. Use an empty block if this is intended.";

sub supported_parameters {
    return ();
}

sub default_severity {
    return $SEVERITY_HIGH;
}

sub default_themes {
    return qw(bugs);
}

sub applies_to {
    return 'PPI::Token::Word';
}

sub violates {
    my ($self, $elem, undef) = @_;

    return if $elem->content ne 'try';
    return if ! is_function_call($elem);

    my $try_block = $elem->snext_sibling() or return;
    my $sib = $try_block->snext_sibling();
    if ($sib->content ne 'catch') {
        return $self->violation($DESC, $EXPL, $elem);
    }
    return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Perl::Critic::Policy::TryTiny::RequireCatch - Always include a "catch" block when using "try"

=head1 VERSION

version 0.001

=head1 DESCRIPTION

Programmers from other programming languages may assume that the following code
does not swallow exceptions:

    use Try::Tiny;
    try {
        # ...
    }
    finally {
        # ...
    };

However, Try::Tiny's implementation always swallows exceptions unless a catch
block has been specified.

The programmer should always include a catch block. The block may be empty, to
indicate that exceptions are deliberately ignored.

    use Try::Tiny;
    try {
        # ...
    }
    catch {
        # ...
    }
    finally {
        # ...
    };

=head1 CONFIGURATION

This Policy is not configurable except for the standard options.

=head1 KNOWN BUGS

This policy assumes that L<Try::Tiny> is being used, and doesn't check for
whether an alternative like L<TryCatch>.

=head1 AUTHOR

David D Lowe <flimm@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Lokku <cpan@lokku.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
