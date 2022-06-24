#!/usr/bin/env perl

BEGIN { use lib 't2'; require 'testlib.pl'; }

# asm extension

for my $file ("${test}", "${test}.asm") {
	unlink_testfiles;
	path("${test}.asm")->spew("ret");
	capture_ok("./z88dk-z80asm -b $file", "");
	check_bin_file("${test}.bin", bytes(0xC9));
}

unlink_testfiles;
path("${test}.xxx")->spew("ret");
capture_ok("./z88dk-z80asm -b ${test}.xxx", "");
check_bin_file("${test}.bin", bytes(0xC9));

# o extension

for my $file ("${test}", "${test}.o") {
	unlink_testfiles;
	path("${test}.asm")->spew("ret");
	capture_ok("./z88dk-z80asm -b $file", "");
	check_bin_file("${test}.bin", bytes(0xC9));
	
	unlink("${test}.bin", "${test}.asm");
	capture_ok("./z88dk-z80asm -b $file", "");
	check_bin_file("${test}.bin", bytes(0xC9));
}

# -- option separator
unlink_testfiles;
path("-${test}.asm")->spew(<<END);
	nop
END

capture_nok("./z88dk-z80asm -b -${test}.asm", <<END);
error: illegal option: -${test}.asm
END

capture_ok("./z88dk-z80asm -b -- -${test}.asm", "");
is path("-${test}.bin")->slurp_raw, bytes(0);
unlink(<-${test}.*>);

unlink_testfiles;
done_testing;
