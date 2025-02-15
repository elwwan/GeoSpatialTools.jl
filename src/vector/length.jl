
# Length of Line
function line_length(points::Vector{T}, precision = Nothing) where T <: Tuple{Real, Real}
  steps = length(points) > 1 ? length(points)-1 : throw(ArgumentError("Need at least two points to calculate a distance"))
  total = 0
  for i in 1:steps
      total += sqrt( (points[i+1][1]-points[i][1])^2 + (points[i+1][2]-points[i][2])^2 )
  end
  return precision == Nothing ? total : round(total; digits =precision)
end


function line_length(linestring::LineString, precision = nothing)
  return isnothing(precision) ? line_length(linestring.geometry) : round(line_length(linestring.geometry), digits = precision)
end

function line_length(multilinestring::MultiLineString, precision = nothing)
  total = 0
  for line in multilinestring.geometry
      total +=line_length(line)
  end
  return isnothing(precision) ? total : round(total, digits = precision)
end

