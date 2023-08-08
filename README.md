NAME
====

MergeOrderedSeqs - Merge multiple ordered Seqs into a single ordered one.

SYNOPSIS
========

```raku
use MergeOrderedSeqs;

my @ordered = merge-ordered-seqs                      [1, 3, 5], [2, 4, 6];
my @ord2    = merge-ordered-seqs :before(More),       [6, 4, 2], [5, 3, 1];
my @ord3    = merge-ordered-seqs :before{(-2) ** $_}, [5, 3, 1], [2, 4, 6];
my @ord4    = merge-ordered-seqs :before{$^a < $^b},  [1, 3, 5], [2, 4, 6];
```

DESCRIPTION
===========

merge_ordered_seqs() is a function that receives multiple iterables that should be ordered and returns a single Seq also ordered.

AUTHOR
======

Fernando Corrêa <fernandocorrea@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2023 Fernando Corrêa de Oliveira

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

