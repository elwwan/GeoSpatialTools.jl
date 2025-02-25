# Finds midpoint and radius of the circle of a CircularString (needed for length and area calculation)

function midpoint_radius_angle(points::Vector{Point})

  p1, p2, p3 = points
  
  distance1 = sqrt((p2.x - p1.x)^2 + (p2.y - p1.y)^2)
  distance2 = sqrt((p3.x - p2.x)^2 + (p3.y - p2.y)^2)
  distance3 = sqrt((p1.x - p3.x)^2 + (p1.y - p3.y)^2)
  
  abc = distance1 * distance2 * distance3
  
  k_signed = 0.5 * (p1.x * (p2.y - p3.y) +
                    p2.x * (p3.y - p1.y) +
                    p3.x * (p1.y - p2.y))

  k_abs = abs(k_signed)
  k_abs != 0 || throw(DomainError("The points are collinear and do not form a valid triangle."))
  radius = abc / (4 * k_abs)
  
  center_x = ((p1.x^2 + p1.y^2) * (p2.y - p3.y) +
              (p2.x^2 + p2.y^2) * (p3.y - p1.y) +
              (p3.x^2 + p3.y^2) * (p1.y - p2.y)) / (4 * k_signed)
              
  center_y = ((p1.x^2 + p1.y^2) * (p3.x - p2.x) +
              (p2.x^2 + p2.y^2) * (p1.x - p3.x) +
              (p3.x^2 + p3.y^2) * (p2.x - p1.x)) / (4 * k_signed)
  

  vec1 = Point(p1.x - center_x, p1.y - center_y, nothing, nothing)
  vec3 = Point(p3.x - center_x, p3.y - center_y, nothing, nothing)

  dot_product = vec1.x * vec3.x + vec1.y * vec3.y
  magnitude1 = sqrt(vec1.x^2 + vec1.y^2)
  magnitude3 = sqrt(vec3.x^2 + vec3.y^2)
  ratio = dot_product / (magnitude1 * magnitude3)
  clamped_ratio = clamp(ratio, -1.0, 1.0)
  angle = acos(clamped_ratio)

  return Point(center_x, center_y, nothing, nothing), radius, angle
end
