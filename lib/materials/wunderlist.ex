require IEx

defmodule Materials.Wunderlist do
  use HTTPotion.Base

  def process_url(url) do
    "https://a.wunderlist.com/api/v1/" <> url
  end

  def process_request_headers(headers) do
    Keyword.merge(
      headers,
      "X-Client-ID": client_id(),
      "X-Access-Token": access_token(),
      "Content-Type": "application/json"
    )
  end

  def process_response_body(body) do
    body |> Poison.decode!()
  end

  def client do
    OAuth2.Client.new(
      strategy: __MODULE__,
      client_id: client_id(),
      client_secret: client_secret(),
      redirect_uri: "http://localhost:4000/auth/callback",
      site: "https://www.wunderlist.com",
      authorize_url: "https://www.wunderlist.com/oauth/authorize",
      token_url: "https://www.wunderlist.com/oauth/access_token"
    )
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), state: "alfkjadslfajksdf")
  end

  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> OAuth2.Client.put_param(:client_secret, client.client_secret)
    |> OAuth2.Client.put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end

  def get_lists do
    get("lists").body()
  end

  def get_tasks(list_id) do
    get("tasks", query: %{list_id: list_id}).body()
  end

  def add_task(list_id, title) do
    body = %{list_id: list_id, title: title}
    # post("tasks", body: Poison.encode!(body))
  end

  def client_id do
    Application.get_env(:materials, :wunderlist_client_id)
  end

  def client_secret do
    Application.get_env(:materials, :wunderlist_client_secret)
  end

  def access_token do
    Application.get_env(:materials, :access_token)
  end
end
