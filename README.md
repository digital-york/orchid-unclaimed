# orcid-unclaimed
Ruby script to identify unclaimed ids in ORCID.

The Research Support Team will provide a report. We need Department in column 1 and ORCID in column 3. Nothing else matters.

Convert it to a CSV leaving the header row in place (the app skips this).

Name the csv file orcids.csv and put it in the application directory.

Get the orcid client id and client secret from lastpass.

Run:

ruby orcid.rb CLIENT_ID CLIENT_SECRET

The script will do the following:

Set up an authentication token with ORCID.

Get the ORCID xml from ORCID for each ID.

Parse the XML and check if it's been claimed or not.

If it hasn't, write a line into a new csv file called 'unclaimed-orcids.csv'.

It takes a while to run.

When it's done, send the file to RST.