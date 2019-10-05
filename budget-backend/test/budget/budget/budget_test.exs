defmodule Budget.BudgetTest do
  use Budget.DataCase

  alias Budget.Budget

  describe "goals" do
    alias Budget.Budget.Goal

    @valid_attrs %{amount: 42}
    @update_attrs %{amount: 43}
    @invalid_attrs %{amount: nil}

    def goal_fixture(attrs \\ %{}) do
      {:ok, goal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Budget.create_goal()

      goal
    end

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Budget.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Budget.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      assert {:ok, %Goal{} = goal} = Budget.create_goal(@valid_attrs)
      assert goal.amount == 42
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Budget.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{} = goal} = Budget.update_goal(goal, @update_attrs)
      assert goal.amount == 43
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Budget.update_goal(goal, @invalid_attrs)
      assert goal == Budget.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Budget.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Budget.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Budget.change_goal(goal)
    end
  end
end
