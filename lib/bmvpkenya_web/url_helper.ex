defmodule BmvpkenyaWeb.UrlHelper do
  use BmvpkenyaWeb, :verified_routes

  @article_namespace "articles"

  def gen_unique_article_url(article_id) do
    token = Phoenix.Token.sign(BmvpkenyaWeb.Endpoint, @article_namespace, article_id)

    Phoenix.VerifiedRoutes.url(
      BmvpkenyaWeb.Endpoint,
      ~p"/articles/#{article_id}?#{[token: token]}"
    )
  end

  def verify_unique_article_token(token) do
    Phoenix.Token.verify(Bmvpkenya.Endpoint, @article_namespace, token, max_age: :infinity)
  end
end
