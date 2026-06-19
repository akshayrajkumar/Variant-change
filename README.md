# ZVARIANT_LIST_FOR_PROGRAM

## Purpose

`ZVARIANT_LIST_FOR_PROGRAM` is a utility report that reads all variants for a given ABAP report program, displays their stored selection values, enriches them with basic DDIC metadata, and optionally prepares Company Code (`BUKRS`) value replacements based on a custom mapping table.

The program is especially useful during SAP ECC to S/4HANA or HANA migration activities where existing report variants must be reviewed, validated, and in some cases adjusted before cutover or testing.

## What the program does

The report performs the following functions:

- Reads variant headers for a selected executable program from `VARID` and variant texts from `VARIT`.
- Reads variant contents using standard SAP function module `RS_VARIANT_CONTENTS`.
- Lists stored selection-screen values for both parameters and select-options.
- Resolves basic DDIC metadata for selection fields such as data element, check table, reference field, and domain.
- Provides an optional BUKRS remapping mode to compare old and new company code values using custom table `ZEOS_BUKRS`.
- Builds a preview of proposed BUKRS changes before saving variants.
- Allows variant content update through a custom SALV toolbar action.
- Supports optional TSV/Excel-style frontend download for normal variant display output.

## Why it is useful in ECC to HANA / S/4HANA migration

During ECC to HANA or ECC to S/4HANA transformation projects, old report variants often contain legacy organizational values, obsolete company codes, or selection values that are no longer valid in the target landscape. These variants are frequently missed during migration preparation because they are stored as user/business execution artifacts rather than core customizing.

This program helps reduce that risk by giving functional and technical teams a quick way to inspect variant contents program by program. It is particularly valuable in these scenarios:

- **Company code harmonization**: identify and replace old `BUKRS` values in variants after organizational redesign.
- **Regression test preparation**: check whether business users will execute reports with outdated variant values after migration.
- **Cutover readiness**: preview which variants are impacted before mass usage in the target system.
- **Post-migration cleanup**: validate whether copied or migrated variants still contain correct business values.
- **Support and hypercare**: troubleshoot report failures caused by invalid or obsolete variant entries.

In practice, this report acts as a lightweight variant analysis and remediation utility for migration, conversion, and data harmonization activities.

## Main processing flow

1. Enter the target report name and optional variant filter.
2. The program reads all matching variants for that report.
3. Each variant is opened with `RS_VARIANT_CONTENTS`.
4. Stored parameter/select-option values are converted into output rows.
5. DDIC lookup is performed for each selection field.
6. If BUKRS change mode is selected, the program compares existing values with mapping entries from `ZEOS_BUKRS`.
7. Changed entries are shown in a preview ALV.
8. The user can review the result and trigger save for changed variants.

## Selection screen fields

| Field | Purpose |
|---|---|
| `P_REPID` | Report/program name whose variants should be analyzed. |
| `S_VAR` | Optional variant name filter. |
| `P_BUKCHG` | Enables BUKRS mapping and change preview mode. |
| `P_XLS` | Downloads normal output to a frontend spreadsheet-style file. |
| `P_MAX` | Limits maximum output rows for performance protection. |

## Output modes

### 1. Normal variant analysis output

When BUKRS change mode is not selected, the program displays one row per variant selection entry with:

- program name
- variant name
- variant text
- selection field
- parameter/select-option indicator
- sign / option
- low / high values
- data element
- reference/check table
- reference field
- domain

This mode is useful for analysis, audit, and export.

### 2. BUKRS change preview output

When `P_BUKCHG` is selected, the program also compares variant values against the mapping table and displays a preview containing:

- old low / high value
- new low / high value
- changed indicator
- processing message

This mode is useful before saving updates to variants.

## Mapping table requirement

The BUKRS replacement logic depends on custom table `ZEOS_BUKRS` with at least these fields:

- `OLD_BUKRS`
- `NEW_BUKRS`

The program checks selection fields that look like company code fields, for example:

- `BUKRS`
- `P_BUKRS`
- `S_BUKRS`
- fields ending with `BUKRS`

## How to use the program

### Variant analysis only

1. Execute `ZVARIANT_LIST_FOR_PROGRAM`.
2. Enter the program name in `P_REPID`.
3. Optionally restrict variants in `S_VAR`.
4. Keep `P_BUKCHG` unchecked.
5. Execute.
6. Review variant values in the ALV.
7. Use `P_XLS` if a frontend download is required.

### BUKRS migration / replacement mode

1. Maintain company code mapping entries in `ZEOS_BUKRS`.
2. Execute `ZVARIANT_LIST_FOR_PROGRAM`.
3. Enter the report name in `P_REPID`.
4. Select `P_BUKCHG`.
5. Execute.
6. Review the BUKRS change preview ALV carefully.
7. Use the custom SALV save button to update changed variants.

## Typical migration use cases

- Replace old ECC company codes with new target company codes after reorganization.
- Identify variants that still contain decommissioned company codes.
- Review report variants before user acceptance testing in S/4HANA.
- Validate variant content after system copy, migration rehearsal, or mock cutover.
- Support business teams in cleaning up high-volume operational report variants.

## Technical objects used

- Table `VARID` for variant headers
- Table `VARIT` for variant text
- Structure/table `RSPARAMS` for variant selection contents
- Function module `RS_VARIANT_CONTENTS` to read variant contents
- Function module `RS_CHANGE_CREATED_VARIANT` to update variant contents
- Class `CL_SALV_TABLE` for ALV display
- Custom table `ZEOS_BUKRS` for company code mapping
- DDIC table `DD03L` for basic field metadata lookup

## Benefits

- Speeds up variant review during migration projects
- Reduces risk of report execution with obsolete company code values
- Gives a controlled preview before saving changes
- Helps technical and functional teams validate report readiness
- Supports repeatable cleanup activity across multiple reports

## Limitations and assumptions

- The current logic is focused mainly on company code (`BUKRS`) replacement.
- Metadata lookup is based on `DD03L` field-name matching and may not resolve all complex selection definitions perfectly.
- The save function should be tested carefully in non-production systems before productive use.
- The program is intended for executable report variants, not all possible transaction or screen variant categories.
- Frontend download is a simple text-based spreadsheet export, not native XLSX generation.

## Recommended project usage

Use this program in sandbox, development, or migration rehearsal systems first. Validate mapping quality, review changed variants with business owners, and transport the program only after save behavior is fully tested. For productive migration waves, this utility is best used as a controlled analysis-and-remediation report owned by the technical migration team.
