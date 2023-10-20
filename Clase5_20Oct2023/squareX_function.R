squareX <- function(x) {
  if (is.character(x)) {
    warning("Converting x to numeric")
    x <- as.numeric(x)
  } else {
    # the type checking done here is of course very incomplete
    message("x appears to be numeric")
  }
  x ^ 2 
}