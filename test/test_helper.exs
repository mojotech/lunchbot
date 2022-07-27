ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Lunchbot.Repo, :manual)
Mox.defmock(Lunchbot.HTTPClientMock, for: HTTPoison.Base)
