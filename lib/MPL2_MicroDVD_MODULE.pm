package MPL2_MicroDVD_MODULE;
use Exporter qw(import);
our @EXPORT_OK = qw(checkType checkWords);
my $filename = getcwd;

use constant FPS => 24;
use lib `$filename`;
use TMP_MODULE qw(printRestOfLine);

sub checkType {
	my ($type, $name) = @_;
	my $newFilename = "$name-przesuniete.txt";
	#DLA PLIKOW W FORMACIE: []
	if ($type eq "mpl2") {
		$endTime = "]";
		$beginTime = "[";
	} else {
	#DLA PLIKOW W FORMACIE: {}
		$endTime = "}";
		$beginTime = "{";
	}
	return ($newFilename, $endTime, $beginTime);
}

sub checkWords {
	my ($words_ref, $handle, $beginTime, $endTime,$offset) = @_;
	@words = @{ $words_ref};
	foreach $s (0 .. 0+@words) {
		checkLetters(\@words, $s, $handle, $beginTime, $endTime,$offset);
	}
	print $handle "\n";
}

sub checkLetters {
	my ($words_ref, $s, $handle, $beginTime, $endTime,$offset) = @_;
	@words = @{ $words_ref};
	my @letters = split("", @words[$s]);
	findIntervalOfTime($s, \@letters, $beginTime, $endTime, $handle, $offset);
	print $handle " ";
}

sub findIntervalOfTime {
	my ($s, $letters_ref, $beginTime, $endTime, $handle, $offset) = @_;
	@letters = @{ $letters_ref};
	my $numberOfInterval = 0;
	if($s == "0") { #dla pierwszego wyrazu szukaj indeksu dla $beginTime i końca dla $endTime
		foreach $c (0 .. 0+@letters) {
			if(@letters[$c] eq $beginTime) {
				$numberOfInterval += 1;
				($begin, $end) = findTime(\@letters, $c, $endTime);
				my @timeToPrint = @letters[$begin+1 .. $end-1];
				if($endTime eq "}") {
					print $handle $beginTime,checkTimeBeginMicroDVD(\@timeToPrint, $offset),$endTime;
				} else {
					print $handle $beginTime,checkTimeBeginMPL2(\@timeToPrint, $offset),$endTime;
				}
				if($numberOfInterval eq 2) {last;}
			}
		}
		printRestOfLine($end, $handle, \@letters, 1);
	} else {
		printRestOfLine(0, $handle, \@letters, 0);
	}
}

sub findTime {
	my ($letters_ref, $c, $endTime) = @_;
	@letters = @{ $letters_ref};
	foreach $g ($c + 1 .. 0+@letters) {
		if(@letters[$g] eq $endTime) {
			return ($c, $g);
			}
	}
}

sub checkTimeBeginMicroDVD {
	my ($time_ref, $offset) = @_;
	@time = @{ $time_ref};
	if(join("",(@time)) + $offset * FPS < 0) {
		return 0;
	} else {
		return (join("",(@time)) + $offset * 24);
	}
}

sub checkTimeBeginMPL2 {
	my ($time_ref, $offset) = @_;
	@time = @{ $time_ref};
	if(join("",(@time)) + $offset *10 < 0) {
		return 0;
	} else {
		return (join("",(@time)) + $offset * 10);
	}
}

