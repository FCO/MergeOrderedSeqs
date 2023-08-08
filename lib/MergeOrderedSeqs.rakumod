unit role MergeOrderedSeqs[$before = Less] does Iterator;

=begin pod

=head1 NAME

MergeOrderedSeqs - Merge multiple ordered Seqs into a single ordered one.

=head1 SYNOPSIS

=begin code :lang<raku>

use MergeOrderedSeqs;

my @ordered = merge-ordered-seqs                      [1, 3, 5], [2, 4, 6];
my @ord2    = merge-ordered-seqs :before(More),       [6, 4, 2], [5, 3, 1];
my @ord3    = merge-ordered-seqs :before{(-2) ** $_}, [5, 3, 1], [2, 4, 6];
my @ord4    = merge-ordered-seqs :before{$^a < $^b},  [1, 3, 5], [2, 4, 6];

=end code

=head1 DESCRIPTION

merge_ordered_seqs() is a function that receives multiple iterables that should be ordered and returns a single Seq also ordered.

=head1 AUTHOR

Fernando Corrêa <fernandocorrea@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2023 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

has Iterator @.iterators;
has          @.next;
has UInt     @.have-value = True xx @!iterators;
has          &!is-before = do given $before {
    when Order {
        -> $a, $b { $a cmp $b ~~ $before }
    }
    when *.count == 1 {
        -> $a, $b { $before.($a) cmp $before.($b) ~~ Less }
    }
    default {
        $before
    }
}

method TWEAK(|) {
    for ^@!iterators -> UInt $index {
        self!populate-next($index)
    }
}

method !populate-next(UInt $index) {
    my $value := @!iterators[$index].pull-one;
    if $value =:= IterationEnd {
        @!have-value[$index] = False;
        return
    }
    @!next[$index] = $value
}

method !index-of-min {
    my $min;
    my $index;
    for ^@!next -> UInt $i {
        next unless @!have-value[$i];
        without $min {
            $min = @!next[$i];
            $index = $i;
            next
        }
        if &!is-before.(@!next[$i], $min) {
            $min = @!next[$i];
            $index = $i
        }
    }
    $index
}

method pull-one {
    return IterationEnd unless @!have-value.first: *.so;
    my UInt $i = self!index-of-min;
    my $value = @!next[$i];
    self!populate-next($i);
    $value
}

sub merge-ordered-seqs(+@iterables, Order :$before) is export {
    Seq.new: MergeOrderedSeqs[|($_ with $before)].new: iterators => @iterables.map: *.iterator
}
