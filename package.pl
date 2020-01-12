#!/usr/bin/perl




print "Clear export dir? [y/N]? ";
$answer = <STDIN>;
chomp $answer;

unless($answer =~ /^[yY]$/) {
    print "Aborting\n";
    exit 0;
}

print "Cleaning export directory..\n";
`rm export/*`;

$export_dir = `pwd`;
chomp $export_dir;
$export_dir .= "/export";

print "Please run export in Godot.  Make sure your export dir is '$export_dir'\n";
print "Press enter to continue.";

$answer = <STDIN>;

print "Creating zip file for itch.io..\n";

$original_name = `ls export | grep '.html'`;
chomp $original_name;
`mv export/$original_name export/index.html`;
`zip export/upload.zip export/*`;

print "Zip file created at $export_dir/upload.zip!\n";
