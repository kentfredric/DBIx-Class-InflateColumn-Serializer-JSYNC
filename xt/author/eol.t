use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::EOL 0.19

use Test::More 0.88;
use Test::EOL;

my @files = (
    'lib/DBIx/Class/InflateColumn/Serializer/JSYNC.pm',
    't/00-compile/lib_DBIx_Class_InflateColumn_Serializer_JSYNC_pm.t',
    't/00-report-prereqs.dd',
    't/00-report-prereqs.t',
    't/basic-oversize.t',
    't/basic-size.t',
    't/basic.t'
);

eol_unix_ok($_, { trailing_whitespace => 1 }) foreach @files;
done_testing;
