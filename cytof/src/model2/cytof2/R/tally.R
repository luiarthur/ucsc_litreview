tally = function(x, mx=max(x)) {
  # x: a vector of integers
  # items: the items to count. By defauly, just counts the unique x's. 
  # returns counts of each integer in union(x,items)
  # basically like table, but mx specifies the max

  items = 1:mx
  items = sort(items)
  num_items = length(items)

  counts = double(num_items)
  names(counts) = items
  
  for (xi in x) counts[xi] = counts[xi] + 1

  counts
}

#x = sample(c(1,3,5), 1000, replace=T)
#table(x)
#tally(x, 15)
#tally(x)
