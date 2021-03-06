% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PDtoMSstatsTMTFormat.R
\name{PDtoMSstatsTMTFormat}
\alias{PDtoMSstatsTMTFormat}
\title{Generate MSstatsTMT required input format for Proteome discoverer output}
\usage{
PDtoMSstatsTMTFormat(input, annotation, fraction = FALSE,
  useNumProteinsColumn = TRUE, useUniquePeptide = TRUE,
  summaryforMultipleRows = sum,
  removePSM_withMissingValue_withinRun = FALSE,
  removeProtein_with1Feature = FALSE,
  which.proteinid = "Master.Protein.Accessions")
}
\arguments{
\item{input}{data name of Proteome discover PSM output. Read PSM sheet.}

\item{annotation}{data frame which contains column Run, Channel, Condition, BioReplicate, Mixture.}

\item{fraction}{indicates whether the data has fractions. If there are fractions, then overlapped peptide ions will be removed and then fractions are combined for each mixture.}

\item{useNumProteinsColumn}{TURE(default) remove shared peptides by information of # Proteins column in PSM sheet.}

\item{useUniquePeptide}{TRUE(default) removes peptides that are assigned for more than one proteins. We assume to use unique peptide for each protein.}

\item{summaryforMultipleRows}{max(default) or sum - when there are multiple measurements for certain feature and certain run, use highest or sum of multiple intensities.}

\item{removePSM_withMissingValue_withinRun}{TRUE(default) will remove PSM with any missing value within each Run.}

\item{removeProtein_with1Feature}{TRUE(default) will remove the proteins which have only 1 peptide and charge.}

\item{which.proteinid}{Use 'Protein.Accessions'(default) column for protein name. 'Master.Protein.Accessions' can be used instead.}
}
\value{
input for protein.summarization function
}
\description{
Convert Proteome discoverer output into the required input format for MSstatsTMT.
}
\examples{
head(raw.input)
head(annotation)
required.input <- PDtoMSstatsTMTFormat(raw.input, annotation)
head(required.input)
}
