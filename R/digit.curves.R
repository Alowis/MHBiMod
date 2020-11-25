#' Creates homogeneous level curve for every model (adapted from the function digit.curves
#' of the geomorph package)
#'
#' @param start A numeric vector of x,y, coordinates for the landmark defining the start of the curve
#' @param curve A matrix (p x k) of 2D coordinates for a set of ordered points defining a curve
#' @param nPoints Numeric how many semilandmarks to place equidistantly along the curve (not counting beginning and end points)
#' @param close Logical Whether the curve is closed (TRUE) or open (FALSE)

#' @return Function returns a matrix of coordinates for nPoints equally spaced semilandmarks sampled along the curve

digit.curves.p <- function(start, curve, nPoints, closed=TRUE){
  nPoints <- nPoints+2
  if(!is.matrix(curve)) stop("Input must be a p-x-k matrix of curve coordinates")
  nCurvePoints = NROW(curve)
  if(nCurvePoints < 2) stop("curve matrix does not have enough points to estimate any interior points")
  if(nPoints > (nCurvePoints - 1)) {
    if((nCurvePoints - 1) == 1) nPoints = 1
    if((nCurvePoints - 1) > 1) nPoints = nCurvePoints - 2
    cat("\nWarning: because the number of desired points exceeds the number of curve points,")
    cat("\nthe number of points will be truncated to", nPoints, "\n\n")
  }
  start <- as.numeric(start)
  if(!setequal(start, curve[1,])) curve <- rbind(start, curve)
  if(closed) curve <- rbind(curve, curve[1,])
  res <- evenPts.p(curve, nPoints)
  if(closed) res <- res[-NROW(res),]
  res
}
#' basic function for spacing out curve points via linear interpolation (adapted from the function digit.curves
#' of the geomorph package). The main different is that curves are normalized to allow an intercomaprison of confidence scores
#' regardless of the input data.
#' used in digit.curves.p
evenPts.p <- function(x, n){
  x <- as.matrix(na.omit(x))
  # x<-round(x,6)
  # x <-x[order(x[,1],-x[,2]),]
  at1<-scale(x[,1])
  at2<-scale(x[,2])
  x[,1]<-as.vector(scale(x[,1]))
  x[,2]<-as.vector(scale(x[,2]))
  N <- NROW(x); p <- NCOL(x)
  if(N == 1) stop("x must be a matrix")
  if(n < 3) {
    n <- 2
    nn <- 3 # so lapply function works
  } else nn <- n

  if(N == 2) {
    x <- rbind(x, x[2,])
    N <- 3 # third row cut off later
  }
  xx <- x[2:N, ] - x[1:(N - 1), ]
  ds <- as.numeric(sqrt(xx[,1]^2+xx[,2]^2))
  cds <- c(0, cumsum(ds))
  cuts <- cumsum(rep(cds[N]/(n-1), n-1))
  targets <- lapply(1:(nn-2), function(j){
    dtar <- cuts[j]
    ll <- which.max(cds[cds < dtar])
    ul <- ll + 1
    adj <- (dtar- cds[ll])/(cds[[ul]] - cds[ll])
    x[ll,] + adj * (x[ul,] - x[ll,])
  })

  out <- matrix(c(x[1,], unlist(targets), x[N,]), n, p, byrow = TRUE)
  out[,1]<- out[,1]*attr(at1,'scaled:scale')+attr(at1, 'scaled:center')
  out[,2]<-out[,2]*attr(at2,'scaled:scale')+attr(at2, 'scaled:center')
  out
}
