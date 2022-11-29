defmodule GoogleApi.StackdriverLogging.Samples do
  @moduledoc """
  A Sample module having function which sends to Stackdriver Logging.
  """

  @doc """
  Write a log.

  ## Examples

      iex> GoogleApi.StackdriverLogging.Samples.write("your_project_id", "your_log_id", "Hello, Stackdriver!")

  """
  def write(project_id, log_id, text)
      when is_binary(project_id) and is_binary(log_id) and is_binary(text) do
    # Get token which is able to send to Stackdriver Logging with using Goth.
    # Valid scopes are listed up at https://cloud.google.com/logging/docs/access-control#scopes
    scope = "https://www.googleapis.com/auth/logging.write"
    {:ok, %{token: token}} = Goth.Token.for_scope(scope)
    conn = GoogleApi.Logging.V2.Connection.new(token)

    # Resource types and corresponding labels are listed up at https://cloud.google.com/logging/docs/api/v2/resource-list
    monitored_resource = %GoogleApi.Logging.V2.Model.MonitoredResource{
      type: "global",
      labels: %{project_id: project_id}
    }

    # Make an individual log to send to Stackdriver Logging
    # Proper logname is described at logName field in https://cloud.google.com/logging/docs/reference/v2/rest/v2/LogEntry
    # You don't need creating space to store logs. see https://cloud.google.com/logging/docs/api/tasks/creating-logs#creating_logs
    log_name = "projects/#{project_id}/logs/#{log_id}"

    entry = %GoogleApi.Logging.V2.Model.LogEntry{
      resource: monitored_resource,
      logName: log_name,
      textPayload: text
    }

    # Make a log group to send to Stackdriver Logging
    # https://hexdocs.pm/google_api_logging/0.17.0/GoogleApi.Logging.V2.Model.WriteLogEntriesRequest.html
    # By the document above, you may put together logs to make efficient logging and avoid quota limit.
    # However it doesn't matter in a sample, So we send just an individual log.
    entries = %GoogleApi.Logging.V2.Model.WriteLogEntriesRequest{entries: [entry]}

    # Send logs to Stack Driver
    GoogleApi.Logging.V2.Api.Entries.logging_entries_write(conn, body: entries)
  end
end
