defmodule BmvpkenyaWeb.ArticleLive.Show do
  use BmvpkenyaWeb, :live_view

  alias Bmvpkenya.Articles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    article = Articles.get_article!(id)
    current_user_id = socket.assigns.current_user.id

    if article.author_id !== current_user_id do
      raise """
        An unauthorized author tried to assign an article
      """
    end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:article, Articles.get_article!(id))}
  end

  defp page_title(:show), do: "Show Article"
  defp page_title(:edit), do: "Edit Article"
end
