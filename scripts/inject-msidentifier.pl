#!/usr/bin/perl

=head1 NAME

inject-msidentifier.pl -- Inject bibliographic metadata (msIdentifier)
from metadata file into TEI XML files

=head1 SYNOPSIS

inject-msidentifier.pl --data=<DIRECTORY> --meta=<FILE>

=head1 OPTIONS

=over 4

=item B<< --data=<DIRECTORY> >>

Directory containing TEI XML files.

=item B<< --meta=<FILE> >>

File containing bibliographic metadata (x-separated
content, see B<--meta-separator>.

=item B<< --meta-file-index=<INTEGER> >>

Metadata file column number of the corresponding filename,
relative to B<--data>, counting starts at B<0>. Default: B<0>.

=item B<< --meta-key-index=<INTEGER> >>

Metadata file: Column number of wanted metadata value, counting starts
at B<0>. Default: B<7>.

=item B<< --meta-separator=<STRING> >>

Meta data value separator. Default: B<|>.

=item B<< --xpath=<XPATH> >>

XPath where the selected metadata value will be injected into the
TEI XML file. You must use namespaces, the TEI namespace
C<http://www.tei-c.org/ns/1.0> is abbreviated as C<t:>, and you
must provide an absolute path, starting with C</t:TEI/t:teiHeader>.

Default: B<< /t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:repository >>.

=item B<-?>, B<-help>, B<-h>, B<-man>

Print help and exit.

=back

=head1 AUTHOR

Frank Wiegand, L<mailto:wiegand@bbaw.de>, 2022.

=cut

use 5.012;
use warnings;

use Getopt::Long;
use Pod::Usage;
use XML::LibXML;

my ($datadir, $metafile, $help, $man);

# generic defaults
my $metafile_idx = 0;
my $metasep      = '|';

# defaults for this file's task
my $metakey_idx  = 7;
my $xpath = '/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:repository';

GetOptions(
    'data=s'            => \$datadir,
    'meta=s'            => \$metafile,
    'meta-file-index=i' => \$metafile_idx,
    'meta-key-index=i'  => \$metakey_idx,
    'meta-separator=s'  => \$metasep,
    'xpath=s'           => \$xpath,
    'help|?' => \$help,
    'man|h'  => \$man,
) or pod2usage(2);

pod2usage(1) if $help;
pod2usage( -exitval => 0, -verbose => 2 ) if $man;
die "no --data\n" unless $datadir;
die "no --meta\n" unless $metafile;

my $parser = XML::LibXML->new;
my $ns = 'http://www.tei-c.org/ns/1.0';
my $xpc = XML::LibXML::XPathContext->new;
$xpc->registerNs( 't', $ns );

open( my $fh_meta, '<:utf8', $metafile ) or die $!;
my $i = 0;
while( my $line = <$fh_meta> ) {
    chomp $line;

    $i++;
    next if $i == 1; # skip first line

    my @values = split quotemeta($metasep) => $line;

    my $path = sprintf '%s/%s', $datadir, $values[$metafile_idx];
    my $source;
    eval { $source = $parser->load_xml( location => $path ); 1 };
    die $@ if $@;

    $source->setEncoding("UTF-8");

    my ($el) = find_or_create_node( $source, $xpc, $xpath );
    $el->removeChildNodes();
    $el->appendText( $values[$metakey_idx] );

    my $xml = $source->toString(1);
    open( my $fh, '>', $path ) or die $!;
    print $fh $xml;
    close $fh;
}

=head1 FUNCTIONS

=head2 xle

Shortcut for C<< XML::LibXML::Element->new >>.

=cut

sub xle {
    XML::LibXML::Element->new(shift);
}

=head2 find_or_create_node

    my ($el) = find_or_create_node( $source, $xpc, $xpath, $prepend? )

Appends/prepends an element within C<$source> to C<$xpath> using the
context C<$xpc>.

=cut

sub find_or_create_node {
    my ( $source, $xpc, $xpath, $prepend ) = @_;

    my ($ret) = $xpc->findnodes( $xpath, $source );
    return $ret if $ret;

    my $full_path = '';
    foreach my $part ( grep { $_ } split /\// => $xpath ) {
        my ($there) = $xpc->findnodes( "$full_path/$part", $source );
        if ( !$there ) {
            my ( $prefix, $name, $attr_name, $attr_value) = $part =~ /^(?:(\w+):)?(\w+)(?:\[\@([\w:]+)=['"](\w+)['"]\])?$/;
            my $el = xle( $name );
            $el->setNamespace( $ns, '', 1 );
            $el->setAttribute( $attr_name, $attr_value ) if $attr_name;
            my ($ins) = $xpc->findnodes( $full_path, $source );

            if ( $prepend ) {
                my @children = $ins->childNodes();
                if ( !@children ) {
                    $ins->appendChild( $el );
                }
                else {
                    $ins->insertBefore( $el, $children[0] );
                }
            }
            else {
                $ins->appendChild($el);
            }
        }
        $full_path = "$full_path/$part";
    }

    ($ret) = $xpc->findnodes( $full_path, $source );
    return $ret;
}

__END__
