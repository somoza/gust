defmodule Gust.CLI do
  # TODO:add docs 

  alias Gust.Flows
  alias Gust.DAG.Run.Trigger
  require Logger

  @app :gust

  def exec(["trigger_run", dag_name]) do
    load_app()

    dag = Flows.get_dag_by_name(dag_name)
    {:ok, run} = Flows.create_run(%{dag_id: dag.id})

    run = Flows.get_run!(run.id) |> Trigger.dispatch_run()
    Logger.warning("Triggered DAG #{dag.name}; Run: #{run.id}")
  end

  defp load_app do
    Application.ensure_all_started(@app)
  end
end
