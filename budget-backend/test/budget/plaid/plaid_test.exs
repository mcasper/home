defmodule Budget.PlaidTest do
  use Budget.DataCase

  alias Budget.Plaid

  describe "items" do
    alias Budget.Plaid.Item

    @valid_attrs %{access_token: "some access_token"}
    @update_attrs %{access_token: "some updated access_token"}
    @invalid_attrs %{access_token: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Plaid.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Plaid.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Plaid.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Plaid.create_item(@valid_attrs)
      assert item.access_token == "some access_token"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Plaid.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Plaid.update_item(item, @update_attrs)
      assert item.access_token == "some updated access_token"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Plaid.update_item(item, @invalid_attrs)
      assert item == Plaid.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Plaid.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Plaid.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Plaid.change_item(item)
    end
  end
end
