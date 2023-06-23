defmodule StarwarsApi.Router do
  use Plug.Router

  plug(Plug.Logger)

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/healthcheck" do
    case Mongo.command(:mongo, ping: 1) do
      {:ok, _} ->
        send_resp(conn, 200, "OK")

      {:error, _} ->
        send_resp(conn, 500, "ERROR")
    end
  end

  get "/movies" do
    posts =
      Mongo.find(:mongo, "movies", %{})
      |> Enum.map(&Map.delete(&1, "_id"))
      |> Enum.to_list()
      |> Jason.encode!()

    conn |> put_resp_content_type("application/json") |> send_resp(200, posts)
  end

  get "/movies/:id" do
    id = conn.params["id"] |> String.to_integer()

    case Mongo.find_one(:mongo, "movies", %{"id" => id}) do
      nil ->
        send_resp(conn, 404, "Not Found")

      {:error, _} ->
        send_resp(conn, 500, "DB ERROR")

      movie ->
        movie = Map.delete(movie, "_id")
        conn |> put_resp_content_type("application/json") |> send_resp(200, Jason.encode!(movie))
    end
  end

  post "/movies" do
    # No validation!
    body = conn.body_params

    sequential_id = (Mongo.find_one(:mongo, "movies", %{}, sort: [id: -1])["id"] || 0) + 1

    case Mongo.insert_one(:mongo, "movies", body |> Map.put("id", sequential_id)) do
      {:ok, result} ->
        send_resp(conn, 201, result.inserted_id |> Jason.encode!())

      {:error, _} ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  put "/movies/:id" do
    id = conn.params["id"] |> String.to_integer()
    body = conn.body_params

    case Mongo.update_one(:mongo, "movies", %{"id" => id}, %{"$set" => body}) do
      {:ok, _} ->
        send_resp(conn, 200, "OK")

      {:error, _} ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  patch "/movies/:id" do
    id = conn.params["id"] |> String.to_integer()
    body = conn.body_params

    case Mongo.update_one(:mongo, "movies", %{"id" => id}, %{"$set" => body}) do
      {:ok, _} ->
        send_resp(conn, 200, "OK")

      {:error, _} ->
        send_resp(conn, 400, "Bad Request")
    end
  end

  delete "/movies/:id" do
    id = conn.params["id"] |> String.to_integer()

    case Mongo.delete_one(:mongo, "movies", %{"id" => id}) do
      {:ok, _} ->
        send_resp(conn, 204, "No Content")

      {:error, _} ->
        send_resp(conn, 400, "Bad Request")
    end
  end
end
