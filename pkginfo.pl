#!/opt/csw/bin/perl
#
#32547 UNIX Systems Programming - Spring 2017
#99180212 - Alvaro Mauricio Diaz Tello
#
#Description:
#pkginfo displays information about  software  packages  that
#are  installed  on  the system.

use Switch;
use Data::Dumper qw(Dumper);

my $length = @ARGV;
my $option1 = $ARGV[0];
my $option2;
my $filename;

#Command Syntax Validation
if ($length == 1 and $option1 eq '-v'){
        get_version();
        exit;
}
elsif ($length == 2){
        $filename = $ARGV[1];
}
elsif ($length == 3){
        $option2 = $ARGV[1];
        $filename = $ARGV[2];
}
else{
        print "Invalid command syntax\n";
        exit;
}

sub get_file_size{
        my $filesize = -s "$filename";
        return $filesize;
}

if ($option1 =~ /^-[asl]/){
        switch ($option1){
                case "-a"       {
                        get_sw_installed();
                }
                case "-s"       {
                        get_sw_size();
                }
                case "-l"       {
                        get_sw_detail();
                }
        }
}
else{
        print "Invalid command syntax 2\n";
}



sub get_sw_installed{
        if (get_file_size() == 0){
                print "No software installed\n";
                exit;
        }
        else{
                open(my $fh, '<:encoding(UTF-8)', $filename)
                        or die "Could not open file '$filename' $!";
                while (my $row = <$fh>){
                        chomp $row;
                        my @fields = split /,/, $row;
                        print "@fields[1]\n";
                }
        }
}

sub get_sw_size{
        my $sw_size = 0;
        open(my $fh, '<:encoding(UTF-8)', $filename)
                or die "Could not open file '$filename' $!";
        while (my $row = <$fh>){
                chomp $row;
                my @fields = split /,/, $row;
                $sw_size = $sw_size + $fields[3];
        }
        print "Total size in kilobytes: $sw_size\n";
}

sub get_sw_detail{
        my @fields;
        open(my $fh, '<:encoding(UTF-8)', $filename)
                or die "Could not open file '$filename' $!";
        while (my $row = <$fh>){
                chomp $row;
                if ($row =~ /$option2/){
                        @fields = split /,/, $row;
                        last;
                }
        }
        if (@fields != 0){
                print "Package @fields[1]:\n";
                print "Category: @fields[0]\n";
                print "Description: @fields[2]\n";
                print "Size in kilobytes: @fields[3]\n";
        }
        else{
                print "No installed package with this name\n";
        }
}

sub get_version{
        print "Assigment4 - Unix systems Programming\n";
        print "Student: Alvaro Diaz\n";
        print "ID: 99180212\n";
}
