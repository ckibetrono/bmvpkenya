defmodule BmvpkenyaWeb.WebhookHandler do
  @behaviour LemonEx.Webhooks.Handler

  alias Bmvpkenya.Accounts.UserNotifier
  alias Bmvpkenya.Articles
  alias BmvpkenyaWeb.UrlHelper

  @impl true
  def handle_event(%LemonEx.Webhooks.Event{name: "order_created"} = event) do
    IO.inspect(event)
    article_id = event.meta["custom_data"]["article_id"]
    user_email = event.data.user_email

    with {:ok, article} <- Articles.get_article(article_id),
         url <- UrlHelper.gen_unique_article_url(article_id),
         {:ok, _email} <- UserNotifier.deliver_article_url(user_email, url, article) do
      :ok
    end
  end

  # You need to handle all incoming events. So, better have a
  # catch-all handler for events that you don't want to handle,
  # but only want to acknowledge.
  @impl true
  def handle_event(_unhandled_event), do: :ok
end
