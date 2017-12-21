defmodule Arithmetic.RedBlackBSTTest do
  use ExUnit.Case
  alias Arithmetic.RedBlackBST

  setup do
    tree = 
      RedBlackBST.new()
      |> RedBlackBST.put("S", 1)
      |> RedBlackBST.put("E", 1)
      |> RedBlackBST.put("X", 1)
      |> RedBlackBST.put("A", 1)
      |> RedBlackBST.put("R", 1)
      |> RedBlackBST.put("C", 1)
      |> RedBlackBST.put("H", 1)
      |> RedBlackBST.put("M", 1)

    {:ok, tree: tree}
  end

  test "get", %{tree: tree} do
    node = RedBlackBST.get(tree, "E")
    assert node.key == "E"

    node = RedBlackBST.get(tree, "Z")
    assert is_nil(node)
  end

  test "size", %{tree: tree} do
    assert RedBlackBST.size(tree) == 8
  end

  test "min", %{tree: tree} do
    min = RedBlackBST.min(tree)
    assert min.key == "A"
  end

  test "max", %{tree: tree} do
    max = RedBlackBST.max(tree)
    assert max.key == "X"
  end

  test "delete min", %{tree: tree} do
    tree = RedBlackBST.delete_min(tree)
    assert RedBlackBST.size(tree) == 7

    node = RedBlackBST.get(tree, "A")
    assert is_nil(node)
  end

  test "delete max", %{tree: tree} do
    tree = RedBlackBST.delete_max(tree)
    assert RedBlackBST.size(tree) == 7

    node = RedBlackBST.get(tree, "X")
    assert is_nil(node)
  end

  test "delete", %{tree: tree} do
    tree = RedBlackBST.delete(tree, "Z")
    assert RedBlackBST.size(tree) == 8
    
    node = RedBlackBST.get(tree, "Z")
    assert is_nil(node)

    tree = RedBlackBST.delete(tree, "E")
    assert RedBlackBST.size(tree) == 7
    
    node = RedBlackBST.get(tree, "E")
    assert is_nil(node)
  end

  test "preorder", %{tree: tree} do
    assert RedBlackBST.preorder(tree) == ["M", "E", "C", "A", "H", "S", "R", "X"]
  end

  test "inorder", %{tree: tree} do
    assert RedBlackBST.inorder(tree) == ["A", "C", "E", "H", "M", "R", "S", "X"]
  end

  test "postorder", %{tree: tree} do
    assert RedBlackBST.postorder(tree) == ["A", "C", "H", "E", "R", "X", "S", "M"]
  end

  test "levelorder", %{tree: tree} do
    assert RedBlackBST.levelorder(tree) == ["M", "E", "S", "C", "H", "R", "X", "A"]
  end
end