- Lifespan = 30-70.
- about +/- 5 years around the year given
- after 0-10 years after the year given
- before: 0-10 years before the year given
- flourished:

  - birth: x - 50 to x - 20
  - death: x + 10 to x + 30

`age`, `born`: birth and death years are known exactly

- Birth: `born`
- Death: `born + age`

`age`, `died`: birth and death years are known exactly

- Birth: `born`
- Death: `born + age`

`age`, `died about`:

- birth: `died_about - 5 - age`, `died_about + 5 - age`
- died: `died_about - 5` to `died_about + 5`

`age`, `died_after`:

- died: `died_after` to `died_after + 10`
- born: `died_after - age`, `died_after - age + 10`

`age_about`, `born`:

- born: `born`
- died: `born + age - 5` to `born + age + 5`

`age_about`, `born`:

- born: `died - age_about - 5` to `died - age_about + 5`
- died: `died`

`age_about`, `died_about`:

- born: `died_about - age_about - 10` to `died_about - age_about + 10`
- died: `died_about - 5`, `died_about + 5`

`age_above`, `born`:

- `born`: `born`
- `died`: `born + age_above` to `born + age_above + 10`

`age_above`, `died_after`:

- `born`: `died_after - age_above` (since this sufficies the age above criteria)
- `died`: `died_after` to `died_after + 10`

`age_above`, `died`:

- `born`: `died - age_above - 10` to `died - age_above`
- `died`: `died`

`age_about`, `died_after`

- `born`: `died_after - age_about - 5` to `died_after + 15`
- `died`: `died_after` to `died_after` + 10

`born`: Lifespan of 30-70 years

- Birth: `born`
- Death: `born + 30` to `born + 70`

`born`, `died`: Dates are known exactly

- Birth: `born`
- Died: `died`

`born`, `died_after`:

- Birth: `born`
- Death: `died_after` to `died_after + 10`

`born`, `lived_after`:

- Birth: `born`
- Death: `lived_after` to `lived_after + 10`

`born_about`, `died`:

- Birth: `born_about - 5` to `born_about + 5`
- Death: `died`

`died`: Lifespan of 30-70 years

- Birth: `born` - 70 to `born - 30`
- Died: `died`

`age_about`, `born_about`:

- Bith: `born_about - 5`, `born_aobut + 5`
- Death: `born_about + age_about - 10` to `born_about + age_about + 10`

`flourished_century`:

- Birth: `flourished_century - 50` to ?
- Death: ? to `flourished_century + 50`
