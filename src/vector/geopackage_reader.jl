using SQLite
using DataFrames

function Open(filename::String)
  return SQLite.DB(filename)
end
function OpenLayer(filename::String, layer_name::Union{Nothing, String} = nothing)
  file = SQLite.DB(filename)
  layers_list = DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM gpkg_contents;")).table_name
  if length(layers_list) == 1
    layer_name = layers_list[1]
  end
  isnothing(layer_name) ? throw(ArgumentError("This file has multiple layers : $layers_list")) : nothing
  return DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM $layer_name;"))
end
function OpenLayer(file::SQLite.DB, layer_name::Union{Nothing, String} = nothing)
  layers_list = DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM gpkg_contents;")).table_name
  if length(layers_list) == 1
    layer_name = layers_list[1]
  end
  isnothing(layer_name) ? throw(ArgumentError("This file has multiple layers : $layers_list")) : nothing
  return DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM $layer_name;"))
end
function GetLayers(filename::String)
  file = SQLite.DB(filename)
  return DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM gpkg_contents;")).table_name
end
function GetLayers(file::SQLite.DB)
  return DataFrame(SQLite.DBInterface.execute(file, "SELECT * FROM gpkg_contents;")).table_name
end

