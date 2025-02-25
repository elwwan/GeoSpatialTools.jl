using SQLite
using DataFrames
using Base.Threads
# Open the files. Doesnt load it 
function Open(filename::String)
    return SQLite.DB(filename)
end

# Open Layer
function OpenLayer(filename::String, layer_name::Union{Nothing, String} = nothing, field::String = "*")
    db = Open(filename)
    try
        return OpenLayer(db, layer_name, field)
    finally
        close(db)
    end
end
function OpenLayer(file::SQLite.DB, layer_name::Union{Nothing, String} = nothing, field::String = "*")
    layers = GetLayers(file)
    
    # Determine layer_name
    if isnothing(layer_name)
        if length(layers) == 0
            throw(ArgumentError("No layers found in the database."))
        elseif length(layers) == 1
            layer_name = layers[1]
        else
            throw(ArgumentError("Multiple layers present: $(join(layers, ", ")). Specify layer_name."))
        end
    end
    
    # Validate layer_name
    if !(layer_name ∈ layers)
        throw(ArgumentError("Layer '$layer_name' not found in layers: $(join(layers, ", "))."))
    end
    
    query = "SELECT $field FROM `$layer_name`"
    return DataFrame(SQLite.DBInterface.execute(file, query))
end


# Get Layers
function GetLayers(filename::String)
    db = Open(filename)
    try
        return GetLayers(db)
    finally
        close(db)
    end
end

function GetLayers(file::SQLite.DB)
    query = "SELECT table_name FROM gpkg_contents"
    df = DataFrame(DBInterface.execute(file, query))
    return df.table_name
end

# Get the fields 
function GetFields(filename::String, layer_name::Union{Nothing, String} = nothing)
    db = Open(filename)
    try
        return GetFields(db, layer_name)
    finally
        close(db)
    end
end
function GetFields(file::SQLite.DB, layer_name::Union{Nothing, String} = nothing)
    layers = GetLayers(file)
    
    if isnothing(layer_name)
        if length(layers) == 0
            throw(ArgumentError("No layers found in the database."))
        elseif length(layers) == 1
            layer_name = layers[1]
        else
            throw(ArgumentError("Multiple layers present: $(join(layers, ", ")). Specify layer_name."))
        end
    end
    
    if !(layer_name ∈ layers)
        throw(ArgumentError("Layer '$layer_name' not found in layers: $(join(layers, ", "))."))
    end
    
    # Get field names
    query = "PRAGMA table_info(`$layer_name`)"
    df = DataFrame(DBInterface.execute(file, query))
    return df.name
end

# Make Geopackage file for each unique value in field
function SaveFileForEachValue(filename::String, field::String, layer_name::Union{Nothing, String} = nothing)
    fields = GetFields(filename, layer_name)
    field ∈ fields || throw(ArgumentError("This field doesn't exist"))
    layer = OpenLayer(filename, layer_name, field)
    unique_values = unique(layer[:, field])
    
    if layer_name === nothing
        layer_name = GetLayers(filename)[1]
    end
    @threads for value in unique_values
        # Create new filename for this value
        new_filename = "$(splitext(filename)[1])_$(value)$(splitext(filename)[2])"
        # Copy the original file
        cp(filename, new_filename; force=true)
        
        # Open the new database and delete rows that don't match the value
        db_new = Open(new_filename)
        try
            DBInterface.execute(db_new, """
                DELETE FROM $(layer_name) 
                WHERE $(field) != '$(value)'
            """)
        finally
            SQLite.close(db_new)
        end
    end
end


SaveFileForEachValue("F:/python/Data/canton.gpkg", "name")

db = Open("F:/python/Data/canton.gpkg")
layer = OpenLayer(db)
layers = GetLayers(db)
fields = GetFields(db)

layer2 = OpenLayer("F:/python/Data/canton.gpkg")
layers2 = GetLayers("F:/python/Data/canton.gpkg")
fields2 = GetFields("F:/python/Data/canton.gpkg")

layer == layer2
layers == layers2
fields == fields2

