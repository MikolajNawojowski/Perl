package TMP_MODULE;
use Exporter qw(import);
our @EXPORT_OK = qw(checkAllWords printRestOfLine
+);
use POSIX;

sub checkAllWords {
	my ($words_ref, $handle, $offset) = @_;
	my @words = @{ $words_ref};
	$zeroIndex = 0;
	foreach $s (0 .. 0+@words) {
		my @letters = split("", @words[$s]);
		if($s == "0") {
			$zeroIndex = getIndexOfBeginTime(@letters);
			my ($seconds, $minutes, $hours) = calculateTimeAfterOffset($zeroIndex, \@letters, $offset);
			@hours = convertIntoArray($hours);
			@minutes = convertIntoArray($minutes);
			@seconds = convertIntoArray($seconds);
			print $handle "@hours:@minutes:@seconds";
			printRestOfLine($zeroIndex, $handle, \@letters, 8);
		}
		else {
			printRestOfLine(0, $handle, \@letters, 0);
		}
	print $handle " ";
	}
	print $handle "\n";
}

sub getIndexOfBeginTime {	
	my @letters = @_;
	foreach $c (0 .. 0+@letters) {
		if(@letters[$c] =~ /0+$/) {
			return $c;
		}
	}
}

sub calculateTimeAfterOffset {
	my ($zeroIndex, $letters_ref, $offset) = @_;
	@letters = @{ $letters_ref};
	my $seconds = getTimeAsValue(\@letters, $zeroIndex+6, $zeroIndex+7);
	my $minutes = getTimeAsValue(\@letters, $zeroIndex+3, $zeroIndex+4);
	my $hours = getTimeAsValue(\@letters, $zeroIndex, $zeroIndex+1);
	($seconds, $minutes, $hours) = convertTimeAfterOffset($seconds, $minutes, $hours, $offset);
	return ($seconds, $minutes, $hours);
}

sub getTimeAsValue {
	my ($letters_ref, $begin, $end) = @_;
	my @letters = @{ $letters_ref};
	return @letters[$begin]*10 + @letters[$end];
}

sub convertTimeAfterOffset {
	my ($seconds, $minutes, $hours,$offset) = @_;
	my $time = $hours * 3600 + $minutes * 60 + $seconds;
	$time = $time + $offset;	
	if($time < 0) {$time = 0;}
	$hours = floor($time/3600);
	$minutes = floor(($time-3600*$hours)/60);
	$seconds = $time-3600*$hours - 60*$minutes;
	return ($seconds, $minutes, $hours);
}


sub convertIntoArray {
	my ($time) = @_;
	return sprintf("%02d",$time);
}

sub printRestOfLine {
	my ($zeroIndex, $handle, $letters_ref, $off) = @_;
	my @letters = @{ $letters_ref};
	foreach $i ($zeroIndex+$off .. 0+@letters) {
		print $handle "@letters[$i]";
	}
}		
