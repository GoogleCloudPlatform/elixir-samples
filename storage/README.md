# Google Cloud Storage Samples

This project includes samples for running Google Cloud Storage

## Installing Dependencies

Install the dependencies, namely `google_api_storage`, using Mix:

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

Now you can run the samples! For example, to list your cloud storage buckets,
type the following into the Interactive Elixir shell:

```ex
iex(1)> GoogleApi.Storage.Samples.list_buckets("YOUR_PROJECT_ID")
your_bucket_1
your_bucket_2
"done!"
```

[adc]: https://cloud.google.com/docs/authentication#getting_credentials_for_server-centric_flow
[service_account_key_file]: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount
