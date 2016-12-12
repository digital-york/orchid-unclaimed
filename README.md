# orcid-unclaimed
Ruby script to identify unclaimed ids in ORCID.

## Pre-requisites

* gems: nokogiri, json, faraday (run gem install for each)
* An ORCID report from PURE - the Research Support Team will provide this.
* The report MUST have Department in column 1 and ORCID in column 3. Nothing else matters.

## Input and Output

* INPUT: orcids.csv
* OUTPUT: unclaimed-orcids.csv, claimed-orcids.csv

## Usage

1. Convert the report to CSV leaving the header row in place (the app skips this).
2. Name it orcids.csv
3. Copy it into the application folder.
4. Retrieve the ORCID client id and client secret from LastPass.
5. Run

```ruby orcid.rb CLIENT_ID CLIENT_SECRET```

The script will do the following:

1. Set up an authentication token with ORCID.
2. Get the ORCID xml from ORCID for each ID.
3. Parse the XML and check if it's been claimed or not.
4. If the ORCID hasn't been claimed, write a line into a new csv file called 'unclaimed-orcids.csv'.
5. If it has been claimed, write a line into a new csv file called 'claimed-orcids.csv'.

It takes a while to run.

When it's done, send the two files to RST.

## Gotchas

If you see an error like this when trying to get the authentication token:

```Error was SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed```

Try the suggestions here: https://gist.github.com/fnichol/867550
