defmodule Arithmetic.Graph do
  defstruct [:v, :e, :adj]

  alias Arithmetic.Graph

  @doc """
  根据顶点数生成图

  ## Examples:
    iex> Arithmetic.Graph.new(13)
    %Arithmetic.Graph{adj: [[], [], [], [], [], [], [], [], [], [], [], [], []], e: 0, v: 13}
  """
  def new(v) do
    %Graph{v: v, e: 0, adj: (for _ <- 1..v, do: [])}
  end

  @doc """
  图的顶点数

  ## Examples:
    iex> alias Arithmetic.Graph
    ...> g = Graph.new(13)
    ...> Graph.v(g)
    13
  """
  def v(%Graph{v: v}), do: v

  @doc """
  图的边数

  ## Examples:
    iex> alias Arithmetic.Graph
    ...> g = Graph.new(13)
    ...> Graph.e(g)
    0
  """
  def e(%Graph{e: e}), do: e

  @doc """
  添加边

  ## Examples:
    iex> alias Arithmetic.Graph
    ...> g = Graph.new(13)
    ...> Graph.add_edge(g, 0, 5)
    %Arithmetic.Graph{adj: [[5], [], [], [], [], [0], [], [], [], [], [], [], []], e: 1, v: 13}
  """
  def add_edge(%Graph{} = g, v, w) do
    adj = g.adj |> List.update_at(v, &(&1 ++ [w]))
    adj = adj |> List.update_at(w, &(&1 ++ [v]))
    %{g | e: g.e + 1, adj: adj}
  end

  @doc """
  顶点指向的顶点

  ## Examples:
    iex> alias Arithmetic.Graph
    ...> g = Graph.new(13)
    ...> g = Graph.add_edge(g, 0, 5)
    ...> Graph.adj(g, 0)
    [5]
    iex> Graph.adj(g, 5)
    [0]
    iex> Graph.adj(g, 13)
    nil
  """
  def adj(%Graph{} = g, v) do
    g.adj |> Enum.at(v)
  end
end