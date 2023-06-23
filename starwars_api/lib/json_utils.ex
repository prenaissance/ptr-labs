defmodule StarwarsApi.JSONUtils do
  @moduledoc """
  JSON serialization extensions
  """

  @doc """
  Serialize BSON to encode MongoDB's ObjectId
  """
  defimpl Jason.Encoder, for: BSON.ObjectId do
    def encode(id, options) do
      # Converting the binary id to a string
      BSON.ObjectId.encode!(id)
      # Encoding the string to JSON
      |> Jason.Encoder.encode(options)
    end
  end

  def normalize_mongo_id(doc) do
    doc
    # Set the id property to the value of _id
    |> Map.put('id', doc["_id"])
    # Delete the _id property
    |> Map.delete("_id")
  end
end
