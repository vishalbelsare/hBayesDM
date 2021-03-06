% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bart_par4.R
\name{bart_par4}
\alias{bart_par4}
\title{Balloon Analogue Risk Task (Ravenzwaaij et al., 2011, Journal of Mathematical Psychology)}
\usage{
bart_par4(data = "choose", niter = 4000, nwarmup = 1000,
  nchain = 4, ncore = 1, nthin = 1, inits = "fixed",
  indPars = "mean", saveDir = NULL, modelRegressor = FALSE,
  vb = FALSE, inc_postpred = FALSE, adapt_delta = 0.95,
  stepsize = 1, max_treedepth = 10)
}
\arguments{
\item{data}{A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "pumps", and "explosion". See \bold{Details} below for more information.}

\item{niter}{Number of iterations, including warm-up.}

\item{nwarmup}{Number of iterations used for warm-up only.}

\item{nchain}{Number of chains to be run.}

\item{ncore}{Integer value specifying how many CPUs to run the MCMC sampling on. Defaults to 1.}

\item{nthin}{Every \code{i == nthin} sample will be used to generate the posterior distribution. Defaults to 1. A higher number can be used when auto-correlation within the MCMC sampling is high.}

\item{inits}{Character value specifying how the initial values should be generated. Options are "fixed" or "random" or your own initial values.}

\item{indPars}{Character value specifying how to summarize individual parameters. Current options are: "mean", "median", or "mode".}

\item{saveDir}{Path to directory where .RData file of model output (\code{modelData}) can be saved. Leave blank if not interested.}

\item{modelRegressor}{Exporting model-based regressors? TRUE or FALSE. Currently not available for this model.}

\item{vb}{Use variational inference to approximately draw from a posterior distribution. Defaults to FALSE.}

\item{inc_postpred}{Include trial-level posterior predictive simulations in model output (may greatly increase file size). Defaults to FALSE.}

\item{adapt_delta}{Floating point number representing the target acceptance probability of a new sample in the MCMC chain. Must be between 0 and 1. See \bold{Details} below.}

\item{stepsize}{Integer value specifying the size of each leapfrog step that the MCMC sampler can take on each new iteration. See \bold{Details} below.}

\item{max_treedepth}{Integer value specifying how many leapfrog steps that the MCMC sampler can take on each new iteration. See \bold{Details} below.}
}
\value{
\code{modelData}  A class \code{"hBayesDM"} object with the following components:
\describe{
 \item{\code{model}}{Character string with the name of the model (\code{"bart_par4"}).}
 \item{\code{allIndPars}}{\code{"data.frame"} containing the summarized parameter
   values (as specified by \code{"indPars"}) for each subject.}
 \item{\code{parVals}}{A \code{"list"} where each element contains posterior samples
   over different model parameters. }
 \item{\code{fit}}{A class \code{"stanfit"} object containing the fitted model.}
 \item{\code{rawdata}}{\code{"data.frame"} containing the raw data used to fit the model, as specified by the user.}
}
}
\description{
Hierarchical Bayesian Modeling of the Balloon Analogue Risk Task with the following 4 parameters: "phi" (prior belief of the balloon not going to be burst), "eta" (updating rate), "gam" (risk-taking parameter), and "tau" (inverse temperature).\cr\cr

Contributor: \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}, \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}, \href{https://ccs-lab.github.io/team/ayoung-lee/}{Ayoung Lee}, \href{https://ccs-lab.github.io/team/jeongbin-oh/}{Jeongbin Oh}, \href{https://ccs-lab.github.io/team/jiyoon-lee/}{Jiyoon Lee}, \href{https://ccs-lab.github.io/team/junha-jang/}{Junha Jang}

\strong{MODEL:}
Reparameterized version (by Harhim Park & Jaeyeong Yang) of Balloon Analogue Risk Task model (Ravenzwaaij et al., 2011) with four parameters
}
\details{
This section describes some of the function arguments in greater detail.

\strong{data} should be assigned a character value specifying the full path and name of the file, including the file extension
(e.g. ".txt"), that contains the behavioral data of all subjects of interest for the current analysis.
The file should be a \strong{tab-delimited} text (.txt) file whose rows represent trial-by-trial observations and columns
represent variables. For the Balloon Analogue Risk Task, there should be three columns of data  with the labels
"subjID", "pumps", "explosion". It is not necessary for the columns to be in this
particular order, however it is necessary that they be labelled correctly and contain the information below:
\describe{
 \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
 \item{\code{"pumps"}}{The number of pumps}
 \item{\code{"explosion"}}{0: intact, 1: burst}
}
\strong{*}Note: The data.txt file may contain other columns of data (e.g. "Reaction_Time", "trial_number", etc.), but only the data with the column
names listed above will be used for analysis/modeling. As long as the columns above are present and labelled correctly,
there is no need to remove other miscellaneous data columns.

\strong{nwarmup} is a numerical value that specifies how many MCMC samples should not be stored upon the
beginning of each chain. For those familiar with Bayesian methods, this value is equivalent to a burn-in sample.
Due to the nature of MCMC sampling, initial values (where the sampling chain begins) can have a heavy influence
on the generated posterior distributions. The \code{nwarmup} argument can be set to a high number in order to curb the
effects that initial values have on the resulting posteriors.

\strong{nchain} is a numerical value that specifies how many chains (i.e. independent sampling sequences) should be
used to draw samples from the posterior distribution. Since the posteriors are generated from a sampling
process, it is good practice to run multiple chains to ensure that a representative posterior is attained. When
sampling is completed, the multiple chains may be checked for convergence with the \code{plot(myModel, type = "trace")}
command. The chains should resemble a "furry caterpillar".

\strong{nthin} is a numerical value that specifies the "skipping" behavior of the MCMC samples being chosen
to generate the posterior distributions. By default, \code{nthin} is equal to 1, hence every sample is used to
generate the posterior.

\strong{Contol Parameters:} adapt_delta, stepsize, and max_treedepth are advanced options that give the user more control
over Stan's MCMC sampler. The Stan creators recommend that only advanced users change the default values, as alterations
can profoundly change the sampler's behavior. Refer to Hoffman & Gelman (2014, Journal of Machine Learning Research) for
more information on the functioning of the sampler control parameters. One can also refer to section 58.2 of the
\href{http://mc-stan.org/documentation/}{Stan User's Manual} for a less technical description of these arguments.
}
\examples{
\dontrun{
# Run the model and store results in "output"
output <- bart_par4(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)

# Visually check convergence of the sampling chains (should like like 'hairy caterpillars')
plot(output, type = 'trace')

# Check Rhat values (all Rhat values should be less than or equal to 1.1)
rhat(output)

# Plot the posterior distributions of the hyper-parameters (distributions should be unimodal)
plot(output)

# Show the WAIC and LOOIC model fit estimates
printFit(output)


}
}
\references{
van Ravenzwaaij, D., Dutilh, G., & Wagenmakers, E. J. (2011). Cognitive model decomposition of the BART: Assessment and application.
Journal of Mathematical Psychology, 55(1), 94-105.
}
\seealso{
We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
}
