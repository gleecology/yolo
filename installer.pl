#!/usr/bin/env perl

#
#

our $D      = $ENV{DEBUG} || 1;
our $NOOP   = 1;
our $user   = $ENV{USER};

my @apt_core = qw(
    libreadline-dev libncurses5-dev     libpcre3-dev 
    libssl-dev      git-core            perl
    redis-server    nss-updatedb        locate
    git-core        nginx
    );

sub main{ 
    run_as( 'root',"date > /tmp/foo" );
    run_as( $user, "date > /tmp/bar" );
    return;

    run_as( 'root', @apt_core );

    my ($base) = '/home/gleeco';
    run_as( $user, (
        qq{ mkdir -p $base/opt/{depot,bin,include,lib,man,sbin,src}  },
        qq{ mkdir -p $base/proj/{data,log} && chmod -R 1777 $base/proj/* },
        qq{ mkdir -p $base/code/            },
    ));
}

sub run_as {
    my $role    = shift;
    warn "ROLE=$role user=$user\n";
    my $cb      = ref $_[-1] eq 'CODE' ?  pop : undef;
    $role       = ($user ne $role) ? qq{ sudo $role } : '';
    for (@_){ 
        my $c   = $role ? qq{ $role "$_"} : $_;
        $D      and print STDERR "cmd: $c \n";
        $NOOP   and next;
        warn    qx{ $role $c };
    }
}

main();
