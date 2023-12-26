defmodule Boltx.QueryBoltV2Test do
  use Boltx.ConnCase, async: true
  @moduletag :bolt_v2
  @moduletag :legacy

  alias Boltx.Types.{Duration, DateTimeWithTZOffset, Point, TimeWithTZOffset}
  alias Boltx.{TypesHelper, Response}

  setup_all do
    # reuse the same connection for all the tests in the suite
    conn = Boltx.conn()
    {:ok, [conn: conn]}
  end

  test "transform Date in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN date($d) AS d"
    params = %{d: ~D[2019-02-04]}

    assert {:ok, %Response{results: res}} = Boltx.query(conn, query, params)
    assert res == [%{"d" => ~D[2019-02-04]}]
  end

  test "transform TimeWithTZOffset in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN time($t) AS t"
    time_with_tz = %TimeWithTZOffset{time: ~T[12:45:30.250876], timezone_offset: 3600}
    params = %{t: time_with_tz}

    assert {:ok, %Response{results: [%{"t" => ^time_with_tz}]}} =
             Boltx.query(conn, query, params)
  end

  test "transform DateTimeWithTZOffset in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN datetime($t) AS t"

    date_time_with_tz = %DateTimeWithTZOffset{
      naive_datetime: ~N[2016-05-24 13:26:08.543267],
      timezone_offset: 7200
    }

    params = %{t: date_time_with_tz}

    assert {:ok, %Response{results: [%{"t" => ^date_time_with_tz}]}} =
             Boltx.query(conn, query, params)
  end

  test "transform DateTime With TimeZone id (UTC) in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN datetime($t) AS t"

    date_time_with_tz_id =
      TypesHelper.datetime_with_micro(~N[2016-05-24 13:26:08.543218], "Etc/UTC")

    params = %{t: date_time_with_tz_id}

    assert {:ok, %Response{results: [%{"t" => ^date_time_with_tz_id}]}} =
             Boltx.query(conn, query, params)
  end

  test "transform DateTime With TimeZone id (Non-UTC) in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN datetime($t) AS t"

    date_time_with_tz_id =
      TypesHelper.datetime_with_micro(~N[2016-05-24 13:26:08.543789], "Europe/Paris")

    params = %{t: date_time_with_tz_id}

    assert {:ok, %Response{results: [%{"t" => ^date_time_with_tz_id}]}} =
             Boltx.query(conn, query, params)
  end

  test "transform NaiveDateTime in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN localdatetime($t) AS t"

    ndt = ~N[2016-05-24 13:26:08.543156]
    params = %{t: ndt}

    assert {:ok, %Response{results: [%{"t" => ^ndt}]}} = Boltx.query(conn, query, params)
  end

  test "transform Time in cypher-compliant data", context do
    conn = context[:conn]
    query = "RETURN localtime($t) AS t"

    t = ~T[13:26:08.543440]
    params = %{t: t}

    assert {:ok, %Response{results: [%{"t" => ^t}]}} = Boltx.query(conn, query, params)
  end
end
