use strict;
use warnings;

package DBIx::Class::InflateColumn::Serializer::JSYNC;

# ABSTRACT: Basic JSON Object Serialization Support.

use JSYNC;

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
