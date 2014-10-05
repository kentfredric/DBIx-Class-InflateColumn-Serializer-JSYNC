use 5.006;    # our
use strict;
use warnings;

package DBIx::Class::InflateColumn::Serializer::JSYNC;

our $VERSION = '0.002000';

# ABSTRACT: Basic JSON Object Serialization Support for DBIx::Class.

# AUTHORITY

use JSYNC;
use Carp qw( croak );

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



=cut

=method get_freezer

    my $freezer = ::JSYNC->get_freezer( $column, $info, $args );
    my $string = $freezer->( $object );
    # $data isa string

=cut

sub get_freezer {
  my ( undef, undef, $col_info, undef ) = @_;
  if ( defined $col_info->{'size'} ) {
    my $size = $col_info->{'size'};
    return sub {
      my $v = JSYNC::Dumper->new()->dump( $_[0] );
      croak('Value Serialization is too big')
        if length($v) > $size;
      return $v;
    };
  }
  return sub {
    return JSYNC::Dumper->new()->dump( $_[0] );
  };
}

=method get_unfreezer

    my $unfreezer = ::JSYNC->get_unfreezer( $column, $info, $args );
    my $object = $unfreezer->( $string );

=cut

sub get_unfreezer {
  return sub {
    return JSYNC::Loader->new()->load( $_[0] );
  };
}

1;
