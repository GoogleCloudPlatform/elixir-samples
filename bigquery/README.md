# Google Cloud BigQuery Samples

This project includes samples for running Google Cloud BigQuery

## Installing Dependencies

Install the dependencies, namely `google_api_big_query`, using Mix:

```sh
mix deps.get
```

## Authentication

Authentication is typically done through [Application Default Credentials][adc]
which means you do not have to change the code to authenticate as long as
your environment has credentials. Start by creating a
[Service Account key file][service_account_key_file]. This file can be used to
authenticate to Google Cloud Platform services from any environment. To use
the file, set the `GOOGLE_APPLICATION_CREDENTIALS` environment variable to
the path to the key file, for example:

    export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service_account.json

## Running the Samples

Use Interactive Elixir and Mix to compile and run the samples

```sh
iex -S mix
```

Now you can run the samples! For example, to list your cloud bigquery buckets,
type the following into the Interactive Elixir shell:

```ex
iex(1)> sql = "SELECT TOP(corpus, 10) as title, COUNT(*) as unique_words
                FROM [publicdata:samples.shakespeare]"
iex(2)> GoogleApi.BigQuery.Samples.sync_query("YOUR_PROJECT_ID", sql)
title: hamlet
unique_words: 5318
title: kinghenryv
unique_words: 5104
title: cymbeline
unique_words: 4875
title: troilusandcressida
unique_words: 4795
title: kinglear
unique_words: 4784
title: kingrichardiii
unique_words: 4713
title: 2kinghenryvi
unique_words: 4683
title: coriolanus
unique_words: 4653
title: 2kinghenryiv
unique_words: 4605
title: antonyandcleopatra
unique_words: 4582
:ok
```

[adc]: https://cloud.google.com/docs/authentication#getting_credentials_for_server-centric_flow
[service_account_key_file]: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount
