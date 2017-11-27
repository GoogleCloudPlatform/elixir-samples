# Google Cloud Datastore Samples

This project includes samples for running Google Cloud Datastore

## Installing Dependencies

Install the dependencies, namely `diplomat`, using Mix:

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

## Setup

These samples require that a Datastore entity of type "Task" is created.
You can create a new [Datastore entity][create_datastore_entity], or just
wing it and let Datastore figure it out. If you want to create an entity,
set "Kind" to be `Task`, "Key identifier" to be type `Custom name` and
value `name`, and a property named `description` and type `String`.

## Running the Samples

Use Interactive Elixir and Mix to compile and run the samples

```sh
iex -S mix
```

Now you can run the samples! For example, to insert a new Datastore entity
of type `Task` and then list the entity you created, do the following:

```ex
iex(1)> GoogleApi.Datastore.Samples.create_task("Get Milk", "2% is best")
:ok
iex(2)> GoogleApi.Datastore.Samples.list_tasks()
Get Milk: 2% is best
```

[adc]: https://cloud.google.com/docs/authentication#getting_credentials_for_server-centric_flow
[service_account_key_file]: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#creatinganaccount
[create_datastore_entity]: https://console.cloud.google.com/datastore/entities/new?project=elixir-samples&kind=Task
