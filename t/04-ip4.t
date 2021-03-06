use v6;
use Test;

plan 5;

use Email::Valid;

my $public = Email::Valid.new( :allow-ip );

my @ipv4_valid     = Q:w/ab@[123.123.0.101] ab@[1.1.1.3] cc@[210.15.18.24] cc@[210.15.18.20] cc@[1.0.2.3] cc@[1.1.2.30]/;
my @ipv4_invalid   = Q:w/ab@[a.b.c.d] ab@[1.2.3.256] ab@1.2.3.4] ab@[1.2.3.4 ab@[0.1.2.3] ab@[0.0.0.0] ab@[1.2.3.0] ab@[127.0.0.1] ab@[127.23.14.2] ab@[10.0.0.10] 
ab@1.1.1.1 ab@[172.17.17.17] ab@[192.168.10.110] ab@[255.255.255.255] zz@[] zz@[0] zz@[1.2] zz@[1.2.3] zz@[0.1.2.3] zz@[0.16.24.18] zz@[255.255.255.255] zz@[100.64.128.12] zz@[240.1.1.2] 
zz@[271.1.1.1] zz@[169.254.12.1] zz@[192.0.2.24] zz@[192.0.0.250] zz@[192.88.99.12] zz@[198.51.100.12] zz@[203.0.113.6] zz@[203.0.010.1] zz@[203.0.10.01]/;


is [ @ipv4_valid.map({ $public.validate( $_ ) }) ],  [ True xx @ipv4_valid.elems ],    'Valid IPv4';
is [ @ipv4_invalid.map({ $public.validate( $_ ) }) ],[ False xx @ipv4_invalid.elems ], 'Invalid IPv4';


my $local = Email::Valid.new( :allow-ip, :allow-local );


@ipv4_valid     = Q:w/ab@[10.123.0.101] ab@[192.168.1.3] cc@[127.0.0.1] cc@[127.23.14.3] cc@[172.23.0.1]/;
@ipv4_invalid   = Q:w/zz@[10.0.0.0] zz@[192.168.15.0] mm@[172.31.31.0] mm@[224.2.1.3] ee@[240.1.1.1] zz@[] zz@[0] zz@[0.123.12.28] zz@[255.255.255.255] zz@[100.127.12.23] zz@[271.1.1.1]
zz@[169.254.255.1]/;

is [ @ipv4_valid.map({ $local.validate( $_ ) }) ],  [ True xx @ipv4_valid.elems ],    'Valid local IPv4';
is [ @ipv4_invalid.map({ $local.validate( $_ ) }) ],[ False xx @ipv4_invalid.elems ], 'Invalid local IPv4';

my $no-ip = Email::Valid.new();


my @ipv4 = Q:w/ab@[123.123.0.101] ab@[1.1.1.3] cc@[210.15.18.24] ab@[10.123.0.101] ab@[192.168.1.3] cc@[127.0.0.1] cc@[172.23.0.1]
    zz@[10.0.0.0] zz@[192.168.15.0] mm@[172.31.31.0] mm@[224.2.1.3] ab@[1.2.3.256] ab@[255.255.255.255] zz@[10.0.0.0] zz@[]/;

is [ @ipv4.map({ $no-ip.validate( $_ ) }) ], [ False xx @ipv4.elems ], 'Disabled IPv4';
