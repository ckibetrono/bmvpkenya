defmodule BmvpkenyaWeb.ArticleLive.Index do
  use BmvpkenyaWeb, :live_view

  alias Bmvpkenya.Articles
  alias Bmvpkenya.Articles.Article

  on_mount({BmvpkenyaWeb.UserAuth, :mount_current_user})

  @impl true
  def mount(_params, _session, socket) do
    author_id = socket.assigns.current_user.id
    {:ok, stream(socket, :articles, Articles.list_articles_by_author_id(author_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Article")
    |> assign(:article, Articles.get_article!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Article")
    |> assign(:article, %Article{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Articles")
    |> assign(:article, nil)
  end

  @impl true
  def handle_info({BmvpkenyaWeb.ArticleLive.FormComponent, {:saved, article}}, socket) do
    {:noreply, stream_insert(socket, :articles, article)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    article = Articles.get_article!(id)
    current_user_id = socket.assigns.current_user.id

    if article.author_id !== current_user_id do
      raise """
        An unauthorized author tried to delete an article #{article.id} by author #{current_user_id}
      """
    end

    {:ok, _} = Articles.delete_article(article)

    {:noreply, stream_delete(socket, :articles, article)}
  end
end
