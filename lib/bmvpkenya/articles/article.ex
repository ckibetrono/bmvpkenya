defmodule Bmvpkenya.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset
  import Money.Validate

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "articles" do
    field :content, :string
    field :title, :string
    field :author_id, :binary_id

    field(:price, Money.Ecto.Composite.Type,
      default_currency: :KES,
      default: Money.new(:KES, "100.00")
    )

    timestamps()
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:author_id, :title, :content, :price])
    |> validate_required([:title, :content, :price, :author_id])
    |> validate_money(:price, greater_than_or_equal_to: Money.new(:KES, "100.00"))
    |> validate_money(:price, less_than_or_equal_to: Money.new(:KES, "1000.00"))
  end
end
