use strict;
use warnings;
package Getopt::Long::Spec;
# ABSTRACT: translate Getopt::Long specs into a hash of attributes
use Getopt::Long::Spec::Builder;
use Getopt::Long::Spec::Parser;

=method new

Simple constructor, takes no options.

=cut
sub new { bless {} shift }

=method parse

Given a valid L<Getopt::Long>
L<option specification|Getopt::Long/"Summary-of-Option-Specifications">,
this method returns a hash describing the spec (see synopsis, above).

This can be called as an object or class method. It will throw an exception
on any error parsing the spec.

=cut
sub parse {
  my $self = shift;
  Getopt::Long::Spec::Parser->parse(@_)
}

=method build

Given a hash describing the attributes of a L<Getopt::Long> option spec,
builds and returns the spec described.

This can be called as an object or class method. It will throw an exception
on any error interpreting the attributes in the hash, for example, if the
attributes conflict with each other, or if they would result in building
an option spec that GoL would reject.

The attributes that may be used are as follows:

=begin :list

= long

The canonical long version of the option

= short

The canonical short version of the option

= aliases

An arrayref of strings, each is a logn or short alias for the option

= val_required

Indicates that a value is required when using this option.

= val_type

Indicates the type of value. Must be one of qw(str int float ext), corresponding
to the [sifo] type indicators in a GoL spec

= dest_type

Indicates the data type of where the value for the option will be stored.
Must be one of qw( array hash ), corresponding to the [@%] desttype
indicators in a GoL spec.

= min_vals

When using a "repetition" clause in a GoL spec, (for example {3,4}), this
is the number that is before the comma - it is the minimum number of arguments
that GoL will consume when using this option.

= max_vals

When using a "repetition" clause in a GoL spec, (for example {3,4}), this
is the number that is after the comma - it is the maximum number of arguments
that GoL will consume when using this option.

= num_vals


When using a "repetition" clause with only I<one> number, (for example {5}),
this is the exact number of arguments that GoL will consume when using this
option.

=end :list

=cut
sub build {
  my $self = shift;
  Getopt::Long::Spec::Builder->build(@_)
}

1 && q{ I do these things because, well, who's stopping me? }; # truth
__END__

=head1 SYNOPSIS

  use Getopt::Long::Spec;
  
  my $gls = Getopt::Long::Spec->new;
  
  my %attrs = $gls->parse('foo|f=i@{3,4}');
  
  my $spec  = $gls->build(
    long         => 'foo',
    short        => 'f'
    val_required => 1,
    val_type     => 'int',
    dest_type    => 'array',
    min_vals     => 3,
    max_vals     => 4,
  );

=head1 DESCRIPTION

This dist provides a means of parsing L<Getopt::Long>'s option specifications
and turning them into hashes describing the spec. Furthermore, it can do the
inverse, turning a hash into an option spec!

Care has been taken to ensure that the output of L</parse> can always be fed
back into L</build> to get the exact same spec - essentially round-tripping
the spec passed to L</parse>.

I'm not yet sure it works the other way arround, that the hashes are round-tripped,
but I am less concerned with that for no other reason than the fact that the code
is already twisted enough as it is to ensure the former situation. :)

=head1 WHY??!?

At some point I decided I wanted to create the ultimate command-line option processor.
However, there are already so many out there, that I also wanted to be compatible with
the most used of them. Since L<Getopt::Long> is pretty much the de-facto standard in
option processors, I realized, I need to make whatever I build able to use GoL's
option specifications... hence this module.

