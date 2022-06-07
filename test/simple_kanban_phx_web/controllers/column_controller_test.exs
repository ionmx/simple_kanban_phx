defmodule SimpleKanbanPhxWeb.ColumnControllerTest do
  use SimpleKanbanPhxWeb.ConnCase

  import SimpleKanbanPhx.KanbanFixtures

  alias SimpleKanbanPhx.Kanban.Column

  @create_attrs %{
    position: 42,
    title: "some title"
  }
  @update_attrs %{
    position: 43,
    title: "some updated title"
  }
  @invalid_attrs %{position: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all columns", %{conn: conn} do
      conn = get(conn, Routes.column_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create column" do
    test "renders column when data is valid", %{conn: conn} do
      conn = post(conn, Routes.column_path(conn, :create), column: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.column_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "position" => 42,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.column_path(conn, :create), column: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update column" do
    setup [:create_column]

    test "renders column when data is valid", %{conn: conn, column: %Column{id: id} = column} do
      conn = put(conn, Routes.column_path(conn, :update, column), column: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.column_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "position" => 43,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, column: column} do
      conn = put(conn, Routes.column_path(conn, :update, column), column: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete column" do
    setup [:create_column]

    test "deletes chosen column", %{conn: conn, column: column} do
      conn = delete(conn, Routes.column_path(conn, :delete, column))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.column_path(conn, :show, column))
      end
    end
  end

  defp create_column(_) do
    column = column_fixture()
    %{column: column}
  end
end
