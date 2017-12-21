defmodule Arithmetic.RedBlackBST.Node do
  defstruct [:key, :val, :n, :color, :left, :right]

  alias Arithmetic.RedBlackBST.Node

  def new(key, val) do
    %Node{
      key: key, 
      val: val,
      n: 1,
      color: :red,
      left: nil,
      right: nil,
    }
  end

  def get(nil, _key), do: nil
  def get(%Node{} = node, key) do
    cond do
      key < node.key -> get(node.left, key)
      key > node.key -> get(node.right, key)
      true -> node
    end
  end

  def put(nil, key, val), do: new(key, val)
  def put(%Node{} = node, key, val) do
    cond do
      key < node.key -> %{node | left: put(node.left, key, val)}
      key > node.key -> %{node | right: put(node.right, key, val)}
      key == node.key -> %{node | val: val}
    end
    |> balance()
  end

  def delete_min(nil), do: nil
  def delete_min(%Node{} = node) do
    if is_nil(node.left) do
      nil
    else
      node =
        if not is_red(node.left) and not is_nil(node.left) and not is_red(node.left.left) do
          move_red_left(node)
        else
          node
        end

      %{node | left: delete_min(node.left)}
    end
    |> balance()
  end

  def delete_max(nil), do: nil
  def delete_max(%Node{} = node) do
    node = if is_red(node.left), do: rotate_right(node), else: node

    if is_nil(node.right) do
      nil
    else
      node =
        if not is_red(node.right) and not is_nil(node.right) and not is_red(node.right.left) do
          move_red_right(node)
        else
          node
        end

      %{node | right: delete_max(node.right)}
    end
    |> balance()
  end

  def delete(nil, _key), do: nil
  def delete(%Node{} = node, key) do
    if key < node.key do
      node =
        if not is_red(node.left) and not is_nil(node.left) and not is_red(node.left.left) do
          move_red_left(node)
        else
          node
        end  

      %{node | left: delete(node.left, key)}
    else
      node =
        if is_red(node.left) do
          rotate_right(node)
        else
          node
        end

      if key == node.key and is_nil(node.right) do
        nil
      else
        node =
          if not is_red(node.right) and not is_nil(node.right) and not is_red(node.right.left) do
            move_red_right(node)
          else
            node
          end

        if key == node.key do
          next = min(node.right)

          %{
            node |
            key: next.key,
            val: next.val,
            color: next.color,
            right: delete_min(node.right)
          }
        else
          %{node | right: delete(node.right, key)}
        end
      end
    end
    |> balance()
  end

  def is_red(nil), do: false
  def is_red(%Node{color: :red}), do: true
  def is_red(%Node{color: :black}), do: false

  def size(nil), do: 0
  def size(%Node{n: n}), do: n

  def min(nil), do: nil
  def min(%Node{left: nil} = node), do: node
  def min(%Node{} = node), do: min(node.left)

  def max(nil), do: nil
  def max(%Node{right: nil} = node), do: node
  def max(%Node{} = node), do: max(node.right)

  defp update_size(nil), do: nil
  defp update_size(%Node{} = node), do: %{node | n: size(node.left) + size(node.right) + 1}

  defp rotate_left(%Node{right: x} = h) do
    x = %{x | color: h.color, n: h.n}
    h = %{h | color: :red, right: x.left} |> update_size()
    %{x | left: h}
  end

  defp rotate_right(%Node{left: x} = h) do
    x = %{x | color: h.color, n: h.n}
    h = %{h | color: :red, left: x.right} |> update_size()
    %{x | right: h}
  end

  defp exchange_color(nil), do: nil
  defp exchange_color(%Node{color: :red} = node), do: %{node | color: :black}
  defp exchange_color(%Node{color: :black} = node), do: %{node | color: :red}

  defp flip_colors(%Node{left: left, right: right} = node) do
    %{exchange_color(node) | left: exchange_color(left), right: exchange_color(right)}
  end

  defp balance(nil), do: nil
  defp balance(%Node{} = node) do
    node = 
      if not is_red(node.left) and is_red(node.right) do
        rotate_left(node)
      else
        node
      end
    
    node =
      if is_red(node.left) and not is_nil(node.left) and is_red(node.left.left) do
        rotate_right(node)
      else
        node
      end

    node = 
      if is_red(node.left) and is_red(node.right) do
        flip_colors(node)
      else
        node
      end

    update_size(node)
  end

  defp move_red_left(%Node{} = node) do
    node = flip_colors(node)

    if is_red(node.right) and not is_nil(node.right) and is_red(node.right.left) do
      node = %{node | right: rotate_right(node.right)} 
      rotate_left(node)
    else
      node
    end
  end

  defp move_red_right(%Node{} = node) do
    node = flip_colors(node)

    if is_red(node.left) and not is_nil(node.left) and is_red(node.left.left) do
      rotate_right(node)
    else
      node
    end
  end

  @doc """
    前序遍历
  """
  def preorder(nil), do: []
  def preorder(%Node{} = node), do: preorder([], node)

  defp preorder(result, nil), do: result
  defp preorder(result, %Node{} = node) do
    result
    |> Enum.concat([node.key])
    |> preorder(node.left)
    |> preorder(node.right)
  end

  @doc """
    中序遍历
  """
  def inorder(nil), do: []
  def inorder(%Node{} = node), do: inorder([], node)

  defp inorder(result, nil), do: result
  defp inorder(result, %Node{} = node) do
    result
    |> inorder(node.left)
    |> Enum.concat([node.key])
    |> inorder(node.right)
  end

  @doc """
    后序遍历
  """
  def postorder(nil), do: []
  def postorder(%Node{} = node), do: postorder([], node)

  defp postorder(result, nil), do: result
  defp postorder(result, %Node{} = node) do
    result
    |> postorder(node.left)
    |> postorder(node.right)
    |> Enum.concat([node.key])
  end

  @doc """
    层级遍历
  """
  def levelorder(nil), do: []
  def levelorder(%Node{} = node), do: levelorder([], [node])
  
  defp levelorder(result, []), do: result
  defp levelorder(result, [nil | queue]), do: levelorder(result, queue)
  defp levelorder(result, [%Node{} = node | queue]) do 
    levelorder(result ++ [node.key], queue ++ [node.left, node.right])
  end

  @doc """
    查找第 k 个元素
  """
  def select(nil, _k), do: {:error, nil}
  def select(%Node{} = node, k) do
    t = size(node.left)

    cond do
      t < k -> select(node.right, k - t - 1)
      t > k -> select(node.left, k)
      true -> {:ok, node}
    end
  end

  @doc """
    检查元素的排名
  """
  def rank(nil, _key), do: {:error, nil}
  def rank(%Node{} = node, key) do
    cond do
      key < node.key -> rank(node.left, key)
      key > node.key -> rank(node.right, key)
      true -> {:ok, size(node.left)}
    end
  end
end


defmodule Arithmetic.RedBlackBST do
  defstruct [:root]

  alias Arithmetic.RedBlackBST
  alias Arithmetic.RedBlackBST.Node

  def new, do: %RedBlackBST{root: nil}

  def get(%RedBlackBST{} = tree, key), do: Node.get(tree.root, key)

  def put(%RedBlackBST{} = tree, key, val) do
    tree = %{tree | root: Node.put(tree.root, key, val)}
    %{tree | root: %{tree.root | color: :black}}
  end

  def delete_min(%RedBlackBST{} = tree) do 
    tree = change_root_to_red(tree)
    tree = %{tree | root: Node.delete_min(tree.root)}
    change_root_to_black(tree)
  end

  def delete_max(%RedBlackBST{} = tree) do
    tree = change_root_to_red(tree)
    tree = %{tree | root: Node.delete_max(tree.root)}
    change_root_to_black(tree)
  end

  def delete(%RedBlackBST{} = tree, key) do
    tree = change_root_to_red(tree)
    tree = %{tree | root: Node.delete(tree.root, key)}
    change_root_to_black(tree)
  end

  def min(%RedBlackBST{} = tree), do: Node.min(tree.root)
  
  def max(%RedBlackBST{} = tree), do: Node.max(tree.root)

  def size(%RedBlackBST{} = tree), do: Node.size(tree.root)

  def preorder(%RedBlackBST{} = tree), do: Node.preorder(tree.root)

  def inorder(%RedBlackBST{} = tree), do: Node.inorder(tree.root)

  def postorder(%RedBlackBST{} = tree), do: Node.postorder(tree.root)

  def levelorder(%RedBlackBST{} = tree), do: Node.levelorder(tree.root)

  def select(%RedBlackBST{} = tree, k), do: Node.select(tree.root, k)

  def rank(%RedBlackBST{} = tree, key), do: Node.rank(tree.root, key)

  defp change_root_to_red(%RedBlackBST{root: nil} = tree), do: tree
  defp change_root_to_red(%RedBlackBST{root: %Node{} = root} = tree) do
    if not Node.is_red(root.left) && not Node.is_red(root.right) do
      %{tree | root: %{root | color: :red}}
    else
      tree
    end
  end

  defp change_root_to_black(%RedBlackBST{root: nil} = tree), do: tree
  defp change_root_to_black(%RedBlackBST{root: %Node{} = root} = tree) do
    %{tree | root: %{root | color: :black}}
  end
end