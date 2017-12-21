defmodule Arithmetic.HeapSort do

  def from(data, compare \\ fn x, y -> x < y end)
  def from(data, compare) do
    data
    |> List.to_tuple()
    |> heapify(div(length(data), 2) - 1, compare)
    |> heap_sort(length(data) - 1, compare)
    |> Tuple.to_list()
  end

  def heapify(data, start, compare) when start >= 0 do
    data
    |> sift_down(start, tuple_size(data) - 1, compare)
    |> heapify(start - 1, compare)
  end
  def heapify(data, _start, _compare), do: data

  def heap_sort(data, finish, compare) when finish > 0 do
    data
    |> swap(0, finish)
    |> sift_down(0, finish - 1, compare)
    |> heap_sort(finish - 1, compare)
  end
  def heap_sort(data, _finish, _compare), do: data
  
  def sift_down(data, root, finish, compare) when root * 2 + 1 <= finish do
    child = root * 2 + 1

    child =
      if child + 1 <= finish and compare.(elem(data, child), elem(data, child + 1)) do
        child + 1
      else 
        child
      end

    if compare.(elem(data, root), elem(data, child)) do
      data
      |> swap(root, child)
      |> sift_down(child, finish, compare)
    else
      data
    end
  end
  def sift_down(data, _root, _finish, _compare), do: data

  def swap(data, i, j) do
    {vi, vj} = {elem(data, i), elem(data, j)}
    data |> put_elem(i, vj) |> put_elem(j, vi)
  end
end