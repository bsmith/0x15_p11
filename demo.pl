#!/usr/bin/perl

use 5.036;
use experimental qw/declared_refs/;
#use local::lib "...dir../extlib"
use Crypt::HSM;

my $library = "/usr/local/lib/libykcs11.dylib";
say "Using $library";
my $hsm = Crypt::HSM->load($library);

my @slots = $hsm->slots;

for my $slot (@slots) {
	for my $mechanism ($hsm->mechanisms($slot)) {
		#my %info = $hsm->mechanism_info($slot, $mechanism)->%*;
		my \%info = $hsm->mechanism_info($slot, $mechanism);
		say sprintf "slot %s, mechanism %s", $slot, $mechanism;
		my sub fmt($val) {
			if (ref($val) eq 'ARRAY') { '[' . join(",", $val->@*) . ']' }
			else { $val }
		}
		say "  ", join(" ", map sprintf("%s=%s", $_, fmt($info{$_})), sort keys %info);
	}
}

use Data::Dump qw/dd/;

dd($hsm->info);
dd($hsm->slot_info(0));
dd($hsm->token_info(0));

say "Opening session to slot $slots[0]";
my $session = $hsm->open_session($slots[0]);

$session->login('user', '123456');
dd($session->info);

my @objects = $session->find_objects({});
dd(\@objects);

my $random = $session->generate_random(64);
dd($random);

