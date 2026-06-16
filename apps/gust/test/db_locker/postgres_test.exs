defmodule DBLocker.PostgresTest do
  alias Gust.DBLocker.Postgres
  use Gust.DataCase

  describe "try_lock/2" do
    test "repo checkouts connection" do
      lock_key = System.unique_integer([:positive])

      Postgres.try_lock(lock_key, fn attempt ->
        send(self(), {:result, attempt})
      end)

      assert_receive {:result, true}

      # I little "hacky" way to support repeated tests (until_fail) without running into the "already unlocked" error
      Gust.Repo.query!("SELECT pg_advisory_unlock($1)", [lock_key])
    end
  end
end
