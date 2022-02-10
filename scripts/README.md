# Scripts

## `split-divs.xsl`

Splits the original data into valid DTABf documents. Usage:

```
saxonb-xslt -ext:on attic/original_data.xml scripts/split-divs.xsl 'dir=data' 'base=letter'
```

## `soldatenbriefe-header.xml`

Containing a DTABf-header with corpus specific metadata information as:

- involved persons/institutions
- transcription guidelines
- licence
- language
- genre

## `soldatenbriefe-meta.csv`

CSV-file containing object specific metadata in 7 columns:

- no.
- date
- writer
- region
- rank
- recipient
- source

