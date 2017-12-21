defmodule Arithmetic.HeapSortTest do
  use ExUnit.Case
  alias Arithmetic.HeapSort

  test "heap sort" do
    assert HeapSort.from([]) == []
    assert HeapSort.from([2, 1, 4, 3]) == [1, 2, 3, 4]
    assert HeapSort.from([2, 1, 4, 3], fn x, y -> x > y end) == [4, 3, 2, 1]
    assert HeapSort.from(["b", "a", "d", "c"]) == ["a", "b", "c", "d"]
    
    seq = [%{key: "b"}, %{key: "a"}, %{key: "d"}, %{key: "c"}]
    res = HeapSort.from(seq, fn x, y -> x.key > y.key end) 
    assert res == [%{key: "d"}, %{key: "c"}, %{key: "b"}, %{key: "a"}]
  end
end