package App::optex::xform;

our $VERSION = "0.01";

=encoding utf-8

=head1 NAME

xform - data transform filter module for optex

=head1 SYNOPSIS

    optex -Mxform

=head1 DESCRIPTION

App::optex::xform is ...

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2020 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

use v5.14;
use warnings;
use Carp;
use utf8;
use open IO => 'utf8', ':std';
use Data::Dumper;

use Text::VisualPrintf::Transform qw();
use Text::VisualWidth::PP qw(vwidth);
use Text::ANSI::Fold::Util qw(ansi_width);

my @xform;

my %param = (
    ansi => {
	length => \&ansi_width,
	match  => qr/\e\[.*?(?:\e\[0*m)+(?:\e\[0*K)*/,
	visible => 2,
    },
    utf8 => {
	length => \&vwidth,
	match  => qr/\P{ASCII}+/,
	visible => 2,
    },
    );

sub encode {
    my %arg = @_;
    my $param = $param{$arg{mode}} or die "$arg{mode}: unkown mode";
    my $xform = Text::VisualPrintf::Transform->new(%$param);
    local $_ = do { local $/; <> };
    if ($xform) {
	$xform->encode($_);
	push @xform, $xform;
    }
    return $_;
}

sub decode {
    my %arg = @_;
    local $_ = do { local $/; <> };
    if (my $xform = pop @xform) {
	$xform->decode($_);
    } else {
	carp "No xform history.";
    }
    print $_;
}

1;

__DATA__

option default -Mutil::filter

option --xform-encode --psub __PACKAGE__::encode=mode=$<shift>
option --xform-decode --osub __PACKAGE__::decode=mode=$<shift>
option --xform --xform-encode $<copy(0,1)> --xform-decode $<shift>

option --xform-ansi --xform ansi
option --xform-utf8 --xform utf8
