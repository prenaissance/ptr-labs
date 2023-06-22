defmodule Web.Quotes do
  def request do
    HTTPoison.get("https://quotes.toscrape.com/")
  end

  def request_quotes do
    with {:ok, response} <- request(),
         {:ok, document} <- Floki.parse_document(response.body),
         quotes <- Floki.find(document, ".quote") do
      Enum.map(quotes, fn q ->
        %{
          author: Floki.find(q, ".author") |> hd |> Floki.text(),
          quote_text: Floki.find(q, ".text") |> hd |> Floki.text() |> String.slice(1..-2),
          tags: Floki.find(q, ".tag") |> Enum.map(&Floki.text/1)
        }
      end)
    end
  end
end
