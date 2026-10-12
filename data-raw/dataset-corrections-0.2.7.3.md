# Dataset audit for dataSDA 0.2.7.3 (2026-10-12)

## Soccer: height and age endpoints were mis-paired

In the pre-correction `soccer_bivar.int`, `t1` held
`[height minimum, age minimum]` and `t2` held `[height maximum, age maximum]`
(for example, team 1 had `t1 = [164, 21]` and `t2 = [192, 35]`). Every `t1`
interval was therefore reversed, and neither column was a height or an age.

The source object is `soccer.bivar` in iRegression 1.2 (CRAN archive,
https://cran.r-project.org/src/contrib/Archive/iRegression/). Its columns are
ordered `yMin, t1Min, t2Min, yMax, t1Max, t2Max`, and its help page defines
T1 as height and T2 as age. A direct comparison shows that the stored values
are exactly `t1 = [t1Min, t2Min]` and `t2 = [t1Max, t2Max]` for all 20 rows.
The conversion paired the minimum and maximum columns in the wrong order.
`y` (weight) already matched `[yMin, yMax]`.

The corrected columns are `t1 = [t1Min, t1Max]` (height, 162--197 cm) and
`t2 = [t2Min, t2Max]` (age, 18--37 years). No number was altered or imputed;
only the pairing of endpoints changed. Every row now matches iRegression
exactly. The old object is preserved in `soccer_bivar_raw_snapshot.R`.
`soccer_bivar.int.R` reproduces the correction and
`soccer_bivar_correction_record.csv` records the changed fields.
