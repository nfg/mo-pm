$Mo'VERSION = '0.22';
no warnings;

sub Mo'import {
    import warnings; $^H |= 1538;
    my $p = caller."'";
    @{ $p . ISA } = Mo'_;
    *{ $p . extends } =
      sub { @{ $p . ISA } = $_[0]; eval "no $_[0] ()" };
    *{ $p . has } = sub {
        my ( $n, %a ) = @_;
        my $d = $a{default}||$a{builder};
        *{ $p . $n } = $d
          ? sub {
            return $#_ ? $$_{$n} = pop
              : exists $$_{$n} ? $$_{$n}
              : ( $$_{$n} = $_->$d ) for @_
          }
          : sub { $#_ ? $_[0]{$n} = $_[1] : $_[0]{$n} }
      }
}

sub Mo'_'new {
    $c = shift;
    my $s = bless {@_}, $c;
    my @c;
    do { unshift @c, $c . "'BUILD" } while $c = ${ $c . "'ISA" }[0];
    defined &$_ && &$_($s) for @c;
    $s
}