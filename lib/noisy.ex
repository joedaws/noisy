defmodule Noisy do
  @moduledoc """
  Documentation for `Noisy`.
  """
  alias VegaLite, as: Vl

  @doc """
  Creates a very simple graphic
  """
  def simple do
    Vl.new(width: 400, height: 400)

    # Specify data source for the graphic, see the data_from_* functions
    |> Vl.data_from_values(iteration: 1..100, score: 1..100)
    # |> Vl.data_from_values([%{iteration: 1, score: 1}, ...])
    # |> Vl.data_from_url("...")

    # Pick a visual mark for the graphic
    |> Vl.mark(:line)
    # |> Vl.mark(:point, tooltip: true)

    # Map data fields to visual properties of the mark, like position or shape
    |> Vl.encode_field(:x, "iteration", type: :quantitative)
    |> Vl.encode_field(:y, "score", type: :quantitative)
  end

  @doc """
  Trying to recreate the global example
  """
  def globe do
    Vl.from_json("""
        {
      "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
      "width": 300,
      "height": 300,
      "projection": {
        "type": "orthographic",
        "rotate": {"expr": "[rotate0, rotate1, 0]"}
      },
      "params": [
        {
          "name": "rotate0",
          "value": 0,
          "bind": {"input": "range", "min": -90, "max": 90, "step": 1}
        },
        {
          "name": "rotate1",
          "value": 0,
          "bind": {"input": "range", "min": -90, "max": 90, "step": 1}
        },
        {
          "name": "earthquakeSize",
          "value": 6,
          "bind": {"input": "range", "min": 0, "max": 12, "step": 0.1}
        }
      ],
      "layer": [
        {
          "data": {"sphere": true},
          "mark": {"type": "geoshape", "fill": "aliceblue"}
        },
        {
          "data": {
            "name": "world",
            "url": "https://vega.github.io/vega-lite/examples/data/world-110m.json",
            "format": {"type": "topojson", "feature": "countries"}
          },
          "mark": {"type": "geoshape", "fill": "mintcream", "stroke": "black"}
        },
        {
          "data": {
            "name": "earthquakes",
            "url": "https://vega.github.io/vega-lite/examples/data/earthquakes.json",
            "format": {"type": "json", "property": "features"}
          },
          "transform": [
            {"calculate": "datum.geometry.coordinates[0]", "as": "longitude"},
            {"calculate": "datum.geometry.coordinates[1]", "as": "latitude"},
            {
              "filter": "(rotate0 * -1) - 90 < datum.longitude && datum.longitude < (rotate0 * -1) + 90 && (rotate1 * -1) - 90 < datum.latitude && datum.latitude < (rotate1 * -1) + 90"
            },
            {"calculate": "datum.properties.mag", "as": "magnitude"}
          ],
          "mark": {"type": "circle", "color": "red", "opacity": 0.25},
          "encoding": {
            "longitude": {"field": "longitude", "type": "quantitative"},
            "latitude": {"field": "latitude", "type": "quantitative"},
            "size": {
              "legend": null,
              "field": "magnitude",
              "type": "quantitative",
              "scale": {
                "type": "sqrt",
                "domain": [0, 100],
                "range": [0, {"expr": "pow(earthquakeSize, 3)"}]
              }
            },
            "tooltip": [{"field": "magnitude"}]
          }
        }
      ]
    }
    """)
  end

  def show_globe do
    vl = globe()
    VegaLite.Viewer.show(vl)
  end
end
