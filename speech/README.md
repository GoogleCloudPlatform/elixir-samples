# Google Cloud Speech Samples

This project includes samples for calling the Google Cloud Speech API

## Installing Dependencies

Install the dependencies, namely `google_api_speech`, using Mix:

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

Now you can run the samples! For example, to transcribe an audio file, type the
following into the Interactive Elixir shell:

```ex
iex(1)> GoogleApi.Speech.Samples.recognize("gs://elixir-samples/audio.raw", :LINEAR16, 32000)
how old is the Brooklyn Bridge
:ok
```

To use your own sample audio sample, [upload an audio file][gcs_upload] to Cloud
Storage. You will need to provide the correct
[encoding and sample rate][encoding_sample_rate] to the API.

[adc]: https://cloud.google.com/docs/authentication#getting_credentials_for_server-centric_flow
[service_account_key_file]: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount
[gcs_upload]: https://cloud.google.com/storage/docs/object-basics
[encoding_sample_rate]: https://cloud.google.com/speech/docs/encoding
