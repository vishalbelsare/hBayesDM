% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/igt_pvl_decay.R
\name{igt_pvl_decay}
\alias{igt_pvl_decay}
\title{Iowa Gambling Task}
\usage{
igt_pvl_decay(data = "choose", niter = 3000, nwarmup = 1000,
  nchain = 4, ncore = 1, nthin = 1, inits = "random",
  indPars = "mean", payscale = 100, saveDir = NULL,
  modelRegressor = FALSE, vb = FALSE, inc_postpred = FALSE,
  adapt_delta = 0.95, stepsize = 1, max_treedepth = 10)
}
\arguments{
\item{data}{A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "choice", "gain", and "loss". See \bold{Details} below for more information.}

\item{niter}{Number of iterations, including warm-up.}

\item{nwarmup}{Number of iterations used for warm-up only.}

\item{nchain}{Number of chains to be run.}

\item{ncore}{Integer value specifying how many CPUs to run the MCMC sampling on. Defaults to 1.}

\item{nthin}{Every \code{i == nthin} sample will be used to generate the posterior distribution. Defaults to 1. A higher number can be used when auto-correlation within the MCMC sampling is high.}

\item{inits}{Character value specifying how the initial values should be generated. Options are "fixed" or "random" or your own initial values.}

\item{indPars}{Character value specifying how to summarize individual parameters. Current options are: "mean", "median", or "mode".}

\item{payscale}{Raw payoffs within data are divided by this number. Used for scaling data. Defaults to 100}

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
 \item{\code{model}}{Character string with the name of the model ("igt_pvl_decay").}
 \item{\code{allIndPars}}{\code{"data.frame"} containing the summarized parameter
   values (as specified by \code{"indPars"}) for each subject.}
 \item{\code{parVals}}{A \code{"list"} where each element contains posterior samples
   over different model parameters. }
 \item{\code{fit}}{A class \code{"stanfit"} object containing the fitted model.}
 \item{\code{rawdata}}{\code{"data.frame"} containing the raw data used to fit the model, as specified by the user.}
}
}
\description{
Hierarchical Bayesian Modeling of the Iowa Gambling Task using the following parameters: "A" (decay rate), "alpha" (outcome sensitivity), "cons" (response consistency), and "lambda" (loss aversion).

\strong{MODEL:}
Prospect Valence Learning (PVL) Decay-RI (Ahn et al., 2014, Frontiers in Psychology)
}
\details{
This section describes some of the function arguments in greater detail.

\strong{data} should be assigned a character value specifying the full path and name of the file, including the file extension
(e.g. ".txt"), that contains the behavioral data of all subjects of interest for the current analysis.
The file should be a \strong{tab-delimited} text (.txt) file whose rows represent trial-by-trial observations and columns
represent variables. For the Iowa Gambling Task, there should be four columns of data with the labels
"subjID", "choice", "gain", and "loss". It is not necessary for the columns to be in this particular order,
however it is necessary that they be labelled correctly and contain the information below:
\describe{
 \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
 \item{\code{"choice"}}{A nominal integer representing which deck was chosen within the given trial (e.g. A, B, C, or D == 1, 2, 3, or 4 in the IGT).}
 \item{\code{"gain"}}{A floating number representing the amount of currency won on the given trial (e.g. 50, 50, 100).}
 \item{\code{"loss"}}{A floating number representing the amount of currency lost on the given trial (e.g. 0, -50).}
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
output <- igt_pvl_decay(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)

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
Ahn, W.-Y., Vasilev, G., Lee, S.-H., Busemeyer, J. R., Kruschke, J. K., Bechara, A., & Vassileva, J. (2014). Decision-making
in stimulant and opiate addicts in protracted abstinence: evidence from computational modeling with pure users. Frontiers in
Psychology, 5, 1376. http://doi.org/10.3389/fpsyg.2014.00849

Hoffman, M. D., & Gelman, A. (2014). The No-U-turn sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. The
Journal of Machine Learning Research, 15(1), 1593-1623.
}
\seealso{
We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
}
