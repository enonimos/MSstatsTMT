#' Summarizing PSM level quantification to protein level quantification
#'
#'
#' We assume missing values are censored and then impute the missing values. Protein-level summarization from PSM level quantification should be performed before testing differentially abundant proteins.
#' After all, normalization between MS runs using normalization channels will be implemented.
#'
#' @export
#' @importFrom utils read.table sessionInfo write.table
#' @param data Name of the output of PDtoMSstatsTMTFormat function or PSM-level quantified data from other tools. It should have columns named Protein, PSM, Mixture, Run, Channel, Condition, BioReplicate, Intensity
#' @param method Four different summarization methods to protein-level can be performed : "msstats"(default), "MedianPolish", "Median", "LogSum".
#' @param normalization Normalization between MS runs. TRUE(default) needs at least one normalization channel in each MS run, annotated by 'Norm' in Condtion column. It will be performed after protein-level summarization. FALSE will not perform normalization step. If data only has one run, then normalization=FALSE.
#' @param MBimpute only for method="msstats". TRUE (default) imputes missing values by Accelated failure model. FALSE uses minimum value to impute the missing value for each PSM.
#' @param maxQuantileforCensored We assume missing values are censored. maxQuantileforCensored is Maximum quantile for deciding censored missing value, for instance, 0.999. Default is Null.
#' @return data.frame with protein-level summarization for each run and channel
#' @examples
#' head(required.input)
#' str(required.input)
#' quant.byprotein <- protein.summarization(required.input,
#'                                          method="msstats",
#'                                          normalization=TRUE,)
#' head(quant.byprotein)

protein.summarization <- function(data,
                                  method = 'msstats',
                                  normalization = TRUE,
                                  MBimpute = TRUE,
                                  maxQuantileforCensored = NULL){

    ## save process output in each step
    allfiles <- list.files()

    num <- 0
    filenaming <- "msstatstmt"
    finalfile <- "msstatstmt.log"

    while (is.element(finalfile,allfiles)) {
        num <- num+1
        finalfile <- paste(paste(filenaming,num,sep="-"),".log",sep="")
    }

    session <- sessionInfo()
    sink("sessionInfo.txt")
    print(session)
    sink()

    processout <- as.matrix(read.table("sessionInfo.txt", header=TRUE, sep="\t"))
    write.table(processout, file=finalfile, row.names=FALSE)

    processout <- rbind(processout, as.matrix(c(" "," ","MSstatsTMT - protein.summarization function"," "),ncol=1))


    ## check input
    required.info <- c('ProteinName', 'PSM', 'Channel', 'BioReplicate', 'Run', 'Mixture', 'Condition', 'Intensity')

    if (!all(required.info %in% colnames(data))) {

        missedAnnotation <- which(!(required.info %in% colnames(data)))
        stop(paste("Please check the required input. ** columns :",
                   required.info[missedAnnotation], ", are missed.", collapse = ", "))

    }

    ## check the option for method
    method.list <- c("LogSum", "Median", "MedianPolish", "msstats")

    if (sum(method == method.list) != 1) {
        stop(" 'method' must be one of the following : 'LogSum', 'Median', MedianPolish', 'msstats' default is 'msstats'. ")
    }

    ## report which options are used.
    processout <- rbind(processout, c(paste("Method for protein summarization :", method)))
    processout <- rbind(processout, c(paste("Normalization between MS runs :", normalization)))

    write.table(processout, file=finalfile, row.names=FALSE)

    return(protein.summarization.function(data,
                                          method,
                                          normalization,
                                          MBimpute,
                                          maxQuantileforCensored))
}
