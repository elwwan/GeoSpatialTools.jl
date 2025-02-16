
# Enveloppe

function envelope(bounding_box::Vector{<:Real})
  xmin, ymin, xmax, ymax = bounding_box
  return Polygon([[
    (xmin, ymin),
    (xmax, ymin),
    (xmax, ymax),
    (xmin, ymax)
  ]])
end