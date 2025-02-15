# Area of polygon
function area(points::Vector{Tuple{T, T}}) where T <: Real
	length(points) < 3 ? throw(ArgumentError("At least three vericies are need to calculate an area")) : nothing
	x = [points[x][1] for x in eachindex(points)]
	y = [points[x][2] for x in eachindex(points)]
	area= abs(sum([i * j for (i, j) in zip(x, vcat(y[2:end], y[1]))]) - 
						 sum([i * j for (i, j) in zip(vcat(x[2:end], x[1]), y)])) / 2
	return area 
end
# Filter with a hole and not with a hole
function area(points::Vector{Vector{T}}) where T <: Tuple{Real, Real}
	if length(points) == 1
		return area(points[1])
	else
		area(points[1]) - sum([area(points[x]) for x in 2:length(points)])
	end
end


# Polygon function
function area(polygon::Polygon, precision = nothing)
	return isnothing(precision) ? area(polygon.geometry) : round(area(polygon.geometry), digits = precision)
end
# MultiPolygon function
function area(multipolygon::MultiPolygon, precision = nothing)
	total = 0
	geometry = multipolygon.geometry
	for polygon in geometry
		total += area(polygon)
	end
	return isnothing(precision) ? total : round(total, digits = precision)
end