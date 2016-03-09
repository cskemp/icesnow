library("lme4")
library("R.matlab")

datafile <- "ridsplusdata.mat"
# index of mean monthly temperature in data set
climinds <- c(6)

# create data frame
alldata <- readMat(datafile)
langnames <- sapply(alldata$rlabels, function(n) n[[1]])
langfamily <- alldata$rfamcodes

reditd <- alldata$reditd
reditdim <- dim(reditd)
climdata <- alldata$rorigclimdata/10
climdim <- dim(climdata)

preds <- matrix(nrow=reditdim[2], ncol=climdim[2])   # will store coefficients
pval <- preds  # will store p values
lcfi <- preds  # will store left side of confidence interval
rcfi <- preds  # will store right side of confidence interval
conv <- preds  # will store convergence flag

colexinds <- 1:reditdim[2]

for ( i in colexinds) {
  print(i)
  sameword <- reditd[,i]
  if ( sum(na.omit(sameword) == 1) < 10 ) { # drop pairs with fewer than 10 attested merges
    next
  }
  names(sameword) <- langnames
  for ( j in climinds ) {
    dat <- data.frame(sameword, predictor=climdata[,j], langfamily)
    completeind <- complete.cases(dat)
    subdat <-  dat[completeind,]
    # make sure we still have 10 or more attested merges 
    if (sum(subdat$sameword==1 ) >= 10) { 
        set.seed(0)
	m1 <- glmer(sameword ~ predictor + (1|langfamily), data = subdat, family = binomial)
        m2 <- glmer(sameword ~ (1|langfamily), data = subdat, family = binomial)
        a <- anova(m2, m1)
	pval[i,j] <- a$Pr[2]
	ms <- summary(m1)
	preds[i,j] <- ms$coefficients[2,1]
	conv[i,j] <- length(m1@optinfo$conv$lme4)
	ci <- tryCatch({
          # fails in some cases 
          confint(m1, "predictor")
	  }, 
	  error = function(cond) {
	    message(cond)
	    return(c(NA,NA))
	  }, 
	  warning=function(cond) {
	    message(cond)
	    return(c(NA,NA))
	  },
	  finally = {
	  }
       )
        lcfi[i,j] <- ci[1]
        rcfi[i,j] <- ci[2]
    }
  }
}

save(preds, pval, file = "datamining_idsplus_me")
writeMat("datamining_idsplus_me.mat", preds=preds, pval=pval, conv=conv, lcfi = lcfi, rcfi = rcfi)


