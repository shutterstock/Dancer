use Test::More tests => 4;

use strict;
use warnings;
use Dancer::FileUtils 'path';

BEGIN { use_ok 'Dancer::Template::Simple' };

my $engine = Dancer::Template::Simple->new;
my $template = path('t', '10_template', 'index.txt');

my $result = $engine->render(
    $template, 
    { var1 => 1, 
      var2 => 2,
      foo => 'one',
      bar => 'two',
      baz => 'three'});

my $expected = 'this is var1="1" and var2=2'."\n\nanother line\n\n one two three\n";
is $result, $expected, "template got processed successfully";

$expected = "one=1, two=2, three=3 - 77";
$template = "one=<% one %>, two=<% two %>, three=<% three %> - <% hash.key %>";

eval { $engine->render($template, { one => 1, two => 2, three => 3}) }; 
like $@, qr/is not a regular file/, "prorotype failure detected";

$result = $engine->render(\$template, { 
    one => 1, two => 2, three => 3, 
    hash => { key => 77 },
});
is $result, $expected, "processed a template given as a scalar ref";
