# Dataset audit for dataSDA 0.2.7.2 (2026-09-22)

## Hardwood: one corrected endpoint

The pre-release `hardwood.hist` ANNT observation 3 has breaks
`2.6, 17.2, 22.7, 14.4` and masses `0.5, 0.4, 0.1`.
Direct inspection of the installed RSDA 3.2.5 `hardwoodBrito` object confirms
the same breaks and masses. Thus the error exists in the upstream package;
it was not introduced by the histogram-string parser.

Source-data correspondence dated 18 September 2026 reports that the final
endpoint is **24.4**, checked against the quantiles file supplied by an author
of *Analysis of Distributional Data* (Brito and Dias, 2022). The correspondence
states that the quantiles file came from M. Ichino and that the original
microdata are unavailable. The spreadsheets themselves were not supplied
with the material available for this audit, so independent inspection of
those files was not possible. The correction relies on that reported check.

The last bin is now `[22.70, 24.40)`. No other endpoint, mass, row, or column
is changed. The old object is preserved in `hardwood_raw_snapshot.R`.
`hardwood.hist.R` reproduces the correction and
`hardwood_correction_record.csv` records the changed field.

Upstream documentation:
https://search.r-project.org/CRAN/refmans/RSDA/html/hardwoodBrito.html

## Crime: confirmed inconsistencies, unresolved replacements

Both `crime.modal` and `crime2.modal` contain the following stored values:

| Observation | Variable | Categories | Values | Total |
| --- | --- | --- | --- | --- |
| gang10 | Crime | violent, non-violent, none | 0.18, 0.15, 0.77 | 1.10 |
| gang14 | Gender | male, female | 0.37, 0.64 | 1.01 |

These are the only non-unit totals among the 45 distributions in each
representation (tolerance 1e-10). Every wide-format cell agrees with its
modal-format counterpart.

The package cites Billard and Diday (2006), *Symbolic Data Analysis:
Conceptual Statistics and Data Mining*. The publisher's book record confirms
the reference, but the original crime table was not accessible in this audit:
https://onlinelibrary.wiley.com/doi/book/10.1002/9780470090183

The locally available *Symbolic Data Analysis: Definitions and Examples*
paper is a different publication and does not provide this crime table.
No independently verified replacement values were found.

A total of 1.10 cannot result solely from rounding three complementary
probabilities to two decimal places (maximum total rounding error 0.015).
For two complementary probabilities, a total of 1.01 can occur at an exact
rounding tie, for example 0.365 and 0.635 under decimal half-up rounding.
Without original values or counts, neither rounding nor a typo is established
as the explanation for gang14. There is no basis for selecting one category
to alter in either row. In particular, making the totals one is not proof
that any guessed value matches the source.

Both crime datasets are therefore unchanged, and their help pages explicitly
document the unresolved inconsistencies. No automatic normalization or
imputation has been applied. Regression tests check agreement of the two
representations and the complete set of known non-unit totals.
