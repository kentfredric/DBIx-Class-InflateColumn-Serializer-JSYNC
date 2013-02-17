use strict;
use warnings;

package DBIx::Class::InflateColumn::Serializer::JSYNC;
BEGIN {
  $DBIx::Class::InflateColumn::Serializer::JSYNC::AUTHORITY = 'cpan:KENTNL';
}
{
  $DBIx::Class::InflateColumn::Serializer::JSYNC::VERSION = '0.001000';
}

# ABSTRACT: Basic JSON Object Serialization Support for DBIx::Class.

use JSYNC;


sub _croak {
  require Carp;
  goto \&Carp::croak;
}


sub get_freezer {
  my ( $class, $column, $info, $args ) = @_;
  if ( defined $info->{'size'} ) {
    my $size = $info->{'size'};
    return sub {
      my $v = JSYNC::dump( $_[0] );
      croak('Value Serialization is too big')
        if length($v) > $size;
      return $v;
    };
  }
  return sub {
    return JSYNC::dump( $_[0] );
  };
}


sub get_unfreezer {
  return sub {
    return JSYNC::load( $_[0] );
  };
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

DBIx::Class::InflateColumn::Serializer::JSYNC - Basic JSON Object Serialization Support for DBIx::Class.

=head1 VERSION

version 0.001000

=head1 DESCRIPTION

This is basically the only serialization backend I could find that wasn't "Dumper()", and actually seemed to work with arbitrary C<bless()>

    package Foo::Result::Thing;
    __PACKAGE__->load_components('InflateColumn::Serializer', 'Core');
    __PACKAGE__->table('thing');

    ....

    __PACKAGE__->add_column(
        data => {
            data_type => 'text',
            serializer_class => 'JSYNC',
        }
    );

=head1 METHODS

=head2 get_freezer

    my $freezer = ::JSYNC->get_freezer( $column, $info, $args );
    my $string = $freezer->( $object );
    # $data isa string

=head2 get_unfreezer

    my $unfreezer = ::JSYNC->get_unfreezer( $column, $info, $args );
    my $object = $unfreezer->( $string );

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
