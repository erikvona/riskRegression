### autoplot.predictCox.R --- 
##----------------------------------------------------------------------
## author: Brice Ozenne
## created: feb 17 2017 (10:06) 
## Version: 
## last-updated: aug 31 2020 (17:13) 
##           By: Brice Ozenne
##     Update #: 825
##----------------------------------------------------------------------
## 
### Commentary: 
## 
### Change Log:
##----------------------------------------------------------------------
## 
### Code:

## * autoplot.predictCox (documentation)
#' @title Plot Predictions From a Cox Model
#' @description Plot predictions from a Cox model.
#' @name autoplot.predictCox
#'  
#' @param object Object obtained with the function \code{predictCox}.
#' @param type [character] The type of predicted value to display.
#' Choices are:
#' \code{"hazard"} the hazard function,
#' \code{"cumhazard"} the cumulative hazard function, 
#' or \code{"survival"} the survival function.
#' @param ci [logical] If \code{TRUE} display the confidence intervals for the predictions.
#' @param band [logical] If \code{TRUE} display the confidence bands for the predictions.
#' @param group.by [character] The grouping factor used to color the prediction curves. Can be \code{"row"}, \code{"strata"}, or \code{"covariates"}.
#' @param reduce.data [logical] If \code{TRUE} only the covariates that does take indentical values for all observations are displayed.
#' @param plot [logical] Should the graphic be plotted.
#' @param digits [integer] Number of decimal places.
#' @param smooth [logical] Should a smooth version of the risk function be plotted instead of a simple function?
#' @param ylab [character] Label for the y axis.
#' @param alpha [numeric, 0-1] Transparency of the confidence bands. Argument passed to \code{ggplot2::geom_ribbon}.
#' @param ... Not used. Only for compatibility with the plot method.
#'
#' @return Invisible. A list containing:
#' \itemize{
#' \item plot: the ggplot object.
#' \item data: the data used to create the plot.
#' }
#'
#' @seealso
#' \code{\link{predictCox}} to compute cumulative hazard and survival based on a Cox model.


## * autoplot.predictCox (examples)
#' @examples
#' library(survival)
#' library(ggplot2)
#'
#' #### simulate data ####
#' set.seed(10)
#' d <- sampleData(1e2, outcome = "survival")
#' seqTau <- c(0,sort(unique(d$time[d$event==1])), max(d$time))
#' 
#' #### Cox model ####
#' m.cox <- coxph(Surv(time,event)~ X1 + X2 + X3,
#'                 data = d, x = TRUE, y = TRUE)
#'
#' ## display baseline hazard
#' e.basehaz <- predictCox(m.cox)
#' autoplot(e.basehaz, type = "cumhazard")
#' autoplot(e.basehaz, type = "cumhazard", smooth = TRUE)
#'
#' ## display baseline hazard with type of event 
#' e.basehaz <- predictCox(m.cox, keep.newdata = TRUE)
#' autoplot(e.basehaz, type = "cumhazard")
#'
#' ## display predicted survival
#' pred.cox <- predictCox(m.cox, newdata = d[1:2,],
#'   times = seqTau, type = "survival", keep.newdata = TRUE)
#' autoplot(pred.cox)
#' autoplot(pred.cox, group.by = "covariates")
#' autoplot(pred.cox, group.by = "covariates", reduce.data = TRUE)
#' 
#' ## predictions with confidence interval/bands
#' pred.cox <- predictCox(m.cox, newdata = d[1:2,,drop=FALSE],
#'   times = seqTau, type = "survival", band = TRUE, se = TRUE, keep.newdata = TRUE)
#' res <- autoplot(pred.cox, ci = TRUE, band = TRUE, plot = FALSE)
#' res$plot + facet_wrap(~row)
#' res2 <- autoplot(pred.cox, ci = TRUE, band = TRUE, alpha = 0.1, plot = FALSE)
#' res2$plot + facet_wrap(~row)
#'
#' #### Stratified Cox model ####
#' m.cox.strata <- coxph(Surv(time,event)~ strata(X1) + strata(X2) + X3 + X4,
#'                       data = d, x = TRUE, y = TRUE)
#'
#' ## baseline hazard
#' pred.baseline <- predictCox(m.cox.strata, keep.newdata = TRUE, type = "survival")
#' res <- autoplot(pred.baseline)
#' res$plot + facet_wrap(~strata, labeller = label_both)
#' 
#' ## predictions
#' pred.cox.strata <- predictCox(m.cox.strata, newdata = d[1:5,,drop=FALSE],
#'                               time = seqTau, keep.newdata = TRUE, se = TRUE)
#'
#' res2 <- autoplot(pred.cox.strata, type = "survival", group.by = "strata", plot = FALSE)
#' res2$plot + facet_wrap(~strata, labeller = label_both)

## * autoplot.predictCox (code)
#' @rdname autoplot.predictCox
#' @method autoplot predictCox
#' @export
autoplot.predictCox <- function(object,
                                type = NULL,
                                ci = object$se,
                                band = object$band,
                                plot = TRUE,
                                smooth = FALSE,
                                digits = 2,
                                alpha = NA,
                                group.by = "row",
                                reduce.data = FALSE,
                                ylab = NULL,
                                 ...){
  
    ## initialize and check    
    possibleType <- c("cumhazard","survival")
    possibleType <- possibleType[possibleType %in% names(object)]

    if(is.null(type)){
        if(length(possibleType) == 1){
            type <- possibleType
        }else{
            stop("argument \'type\' must be specified to choose between ",paste(possibleType, collapse = " "),"\n")
        }
    }else{
        type <- match.arg(type, possibleType)  
    }
    if(is.null(ylab)){
        ylab <- switch(type,
                        "cumhazard" = "cumulative hazard",
                        "survival" = "survival")
    }

    group.by <- match.arg(group.by, c("row","covariates","strata"))

    if((group.by[[1]] == "covariates") && ("newdata" %in% names(object)) == FALSE){
        stop("argument \'group.by\' cannot be \"covariates\" when newdata is missing in the object \n",
             "set argment \'keep.newdata\' to TRUE when calling the predictCox function \n")
    }

    if(group.by[[1]] == "strata" && ("strata" %in% names(object) == FALSE)){
        stop("argument \'group.by\' cannot be \"strata\" when strata is missing in the object \n",
             "set argment \'keep.strata\' to TRUE when calling the predictCox function \n")
    }
  
    if(ci[[1]]==TRUE && (object$se[[1]]==FALSE || is.null(object$conf.level))){
        stop("argument \'ci\' cannot be TRUE when no standard error have been computed \n",
             "set arguments \'se\' and \'confint\' to TRUE when calling the predictCox function \n")
    }
    if(band[[1]] && (object$band[[1]]==FALSE  || is.null(object$conf.level))){
        stop("argument \'band\' cannot be TRUE when the quantiles for the confidence bands have not been computed \n",
             "set arguments \'band\' and \'confint\' to TRUE when calling the predictCox function \n")
    }
    if(object$nTimes!= 0 && any(rank(object$times) != 1:length(object$times))){
        stop("Invalid object. The prediction times must be strictly increasing \n")
    }
    dots <- list(...)
    if(length(dots)>0){
        txt <- names(dots)
        txt.s <- if(length(txt)>1){"s"}else{""}
        stop("unknown argument",txt.s,": \"",paste0(txt,collapse="\" \""),"\" \n")
    }

    ## reshape data
    if(!is.matrix(object[[type]])){
        
        ## baseline hazard/survival
        if(is.null(object[["strata"]])){
            object[[type]] <- rbind(object[[type]])
            if(object$nTimes==0){
                if(0 %in% object$times == FALSE){
                    if(type=="cumhazard"){
                        object[[type]] <- cbind(0,object[[type]])
                    }else if(type=="survival"){
                        object[[type]] <- cbind(1,object[[type]])
                    }
                    object$times <- c(0,object$times)
                    if(!is.null(object$newdata)){
                        object$newdata <- rbind(data.table(start = 0, stop = 0, status = NA, strata = 1, strata.num = 0, eXb = NA, statusM1 = NA, XXXindexXXX = NA),
                                                object$newdata)
                    }
                }
                if(object$lastEventTime %in% object$times == FALSE){
                    object[[type]] <- cbind(object[[type]],utils::tail(object[[type]],1))
                    object$times <- c(object$times,object$lastEventTime)
                    if(!is.null(object$newdata)){
                        object$newdata <- rbind(data.table(start = 0, stop = object$lastEventTime, status = 0, strata = 1, strata.num = 0, eXb = NA, statusM1 = NA, XXXindexXXX = NA),
                                                object$newdata)
                    }
                }
            }

        }else{
            strata <- unique(object[["strata"]])
            n.strata <- length(strata)
            time <- unique(sort(object[["times"]])) 
            n.time <- length(time)
            type.tempo <- matrix(NA, nrow = n.strata, ncol = n.time)

            init <- switch(type,
                           "cumhazard" = 0,
                           "survival" = 1)

            for(iStrata in 1:n.strata){ ## iStrata <- 1
                index.strata <- which(object[["strata"]]==strata[iStrata])
                type.tempo[iStrata,]  <- stats::approx(x = object[["times"]][index.strata],
                                                       y = object[[type]][index.strata],
                                                       yleft = init,
                                                       yright = NA,
                                                       xout = time,
                                                       method = "constant")$y
                
            }
            object[[type]] <- type.tempo
            object[["strata"]] <- strata
            object[["times"]] <- time
            group.by <- "strata"
        }

        newdata <- NULL
        if(object$nTimes==0){
            status <- object$newdata
        }else{
            status <- NULL
        }
    }else{
        newdata <- data.table::copy(object$newdata) ## can be NULL
        if(!is.null(newdata) && reduce.data[[1]]==TRUE){
            test <- unlist(newdata[,lapply(.SD, function(col){length(unique(col))==1})])
            if(any(test)){
                newdata[, (names(test)[test]):=NULL]
            }        
        }
        status <- NULL
    }

    dataL <- predict2melt(outcome = object[[type]], ci = ci, band = band,
                          outcome.lower = if(ci){object[[paste0(type,".lower")]]}else{NULL},
                          outcome.upper = if(ci){object[[paste0(type,".upper")]]}else{NULL},
                          outcome.lowerBand = if(band){object[[paste0(type,".lowerBand")]]}else{NULL},
                          outcome.upperBand = if(band){object[[paste0(type,".upperBand")]]}else{NULL},
                          newdata = newdata,
                          status = status,
                          strata = object$strata,
                          times = object$times,
                          name.outcome = type,
                          group.by = group.by,
                          digits = digits
                          )
    ## display
    gg.res <- predict2plot(dataL = dataL,
                           name.outcome = type,
                           ci = ci,
                           band = band,
                           group.by = group.by,
                           conf.level = object$conf.level,
                           alpha = alpha,
                           smooth = smooth,
                           xlab = if(is.null(object$infoVar)){"time"}else{object$infoVar$time},
                           ylab = ylab
                           )
  
  if(plot){
    print(gg.res$plot)
  }
  
    return(invisible(gg.res))
}

## * predict2melt
predict2melt <- function(outcome, name.outcome,
                         ci, outcome.lower, outcome.upper,
                         band, outcome.lowerBand, outcome.upperBand,
                         newdata, status, strata, times, 
                         group.by, digits){

    patterns <- NULL ## [:CRANtest:] data.table
    n.time <- NCOL(outcome)
    if(!is.null(time)){
        time.names <- times 
    }else{
        time.names <- 1:n.time
    }    
    colnames(outcome) <- paste0(name.outcome,"_",time.names)
    keep.cols <- unique(c("time",name.outcome,"row",group.by))

    ## merge outcome with CI and band ####
    pattern <- paste0(name.outcome,"_")
    if(!is.null(status)){
        Ustrata <- unique(status$strata)
        M.status <- matrix(as.numeric(NA), nrow = NROW(outcome), ncol = NCOL(outcome),
                           dimnames = list(NULL, paste0("status_",time.names)))
        status[,c("index") := match(.SD$stop, times)]

        for(iS in 1:length(Ustrata)){ ## iS <- 1
            iIndex <- which(status$strata == Ustrata[iS])
            iStatus <- status[iIndex, list("nevent" = sum(.SD$status), "index" = unique(.SD$index)),by="stop"]
            M.status[iS, iStatus$index] <- (iStatus$nevent>0)
        }
        ## M.status[1,times[]] <- status[strata==Ustrata[1]]
        ## times
        outcome <- cbind(outcome, M.status)
        pattern <- c(pattern,"status")
    }

    if(ci){
        pattern <- c(pattern,"lowerCI_","upperCI_")
    
        colnames(outcome.lower) <- paste0("lowerCI_",time.names)
        colnames(outcome.upper) <- paste0("upperCI_",time.names)
    }
    if(band){
        pattern <- c(pattern,"lowerBand_","upperBand_")
        keep.cols <- c(keep.cols,"lowerBand","upperBand")
        
        colnames(outcome.lowerBand) <- paste0("lowerBand_",time.names)
        colnames(outcome.upperBand) <- paste0("upperBand_",time.names)

    }
    outcome <- data.table::data.table(
                               cbind(outcome,
                                     outcome.lower, outcome.upper,
                                     outcome.lowerBand,outcome.upperBand)
                           )

    ## merge with convariates ####
    outcome[, row := 1:.N]
    if(group.by == "covariates"){
        cov.names <- names(newdata)
        newdata <- newdata[, (cov.names) := lapply(cov.names,function(col){
            if (is.numeric(.SD[[col]]))
                paste0(col,"=",round(.SD[[col]],digits)) else paste0(col,"=",.SD[[col]])})]
        outcome[, ("covariates") := interaction(newdata,sep = " ")]
    }else if(group.by == "strata"){
        outcome[, strata := strata]
    }
    
    ## reshape to long format ####
    dataL <- melt(outcome, id.vars = union("row",group.by),
                  measure = patterns(pattern),
                  variable.name = "time", value.name = gsub("_","",pattern))

    dataL[, time := as.numeric(as.character(factor(time, labels = time.names)))]
    dataL <- dataL[!is.na(dataL[[name.outcome]])]
    return(dataL)    
}

## * predict2plot
predict2plot <- function(dataL, name.outcome,
                         ci, band, group.by, smooth,                        
                         conf.level, alpha, xlab, ylab){

    lowerCI <- upperCI <- lowerBand <- upperBand <- timeRight <- NULL
    ## duplicate observations to obtain step curves ####
    keep.cols <- unique(c("time",name.outcome,"row",group.by))
    if(ci){
        keep.cols <- c(keep.cols,"lowerCI","upperCI")
    }
    if(band){
        keep.cols <- c(keep.cols,"lowerBand","upperBand")
    }

    ## set at t- the value of t-1
    dtTempo <- copy(dataL)

    vec.outcome <- name.outcome
    if(ci){
        vec.outcome <- c(vec.outcome,"lowerCI","upperCI")
    }
    if(band){
        vec.outcome <- c(vec.outcome,"lowerBand","upperBand")
    }
    dataL[,c("timeRight") := c(.SD$time[2:.N]-1e-12,.SD$time[.N]+1e-12), by = "row"] 

    if(smooth){
        if(ci){
            dataL[, c("lowerCI.smooth") := stats::loess(lowerCI ~ time, data = .SD)$fitted, by = "row"]
            dataL[, c("upperCI.smooth") := stats::loess(upperCI ~ time, data = .SD)$fitted, by = "row"]
        }
        if(band){
            dataL[, c("lowerBand.smooth") := stats::loess(lowerBand ~ time, data = .SD)$fitted, by = "row"]
            dataL[, c("upperBand.smooth") := stats::loess(upperBand ~ time, data = .SD)$fitted, by = "row"]
        }
    }
    dataL[[group.by]] <- as.factor(dataL[[group.by]])

    ## display ####
    labelCI <- paste0(conf.level*100,"% confidence \n interval")
    labelBand <- paste0(conf.level*100,"% confidence \n band")

    gg.base <- ggplot2::ggplot(data = dataL, mapping = ggplot2::aes(group = row))
    if(band){ ## confidence band
        if(smooth){
            if(!is.na(alpha)){
                gg.base <- gg.base + ggplot2::geom_ribbon(ggplot2::aes_string(x = "time", ymin = "lowerBand.smooth", ymax = "upperBand.smooth"), alpha = alpha)
            }else{
                gg.base <- gg.base + ggplot2::geom_smooth(eval(parse(text = paste0("ggplot2::aes(x = ","time",", y = ","lowerBand.smooth",", color = ",group.by,", linetype = \"band\")"))),
                                                          se = FALSE, method = "loess", formula = y~x)
                gg.base <- gg.base + ggplot2::geom_smooth(eval(parse(text = paste0("ggplot2::aes(x = ","time",", y = ","upperBand.smooth",", color = ",group.by,", linetype = \"band\")"))),
                                                          se = FALSE, method = "loess", formula = y~x)
            }
        }else{
            if(!is.na(alpha)){
                gg.base <- gg.base + ggplot2::geom_rect(ggplot2::aes(xmin = time, xmax = timeRight, ymin = lowerBand, ymax = upperBand,
                                                            fill = labelBand), linetype = 0, alpha = alpha)
                gg.base <- gg.base + scale_fill_manual("", values="grey12")        
            }else{
                gg.base <- gg.base + ggplot2::geom_segment(ggplot2::aes(x = time, y = lowerBand, xend = timeRight, yend = lowerBand, color = "band"),
                                                           size = 1.2)
                gg.base <- gg.base + ggplot2::geom_segment(ggplot2::aes(x = time, y = upperBand, xend = timeRight, yend = upperBand, color = "band"),
                                                           size = 1.2)
            }
        }
    }
    
    if(ci){ ## confidence interval
        if(smooth){
            if(!is.na(alpha)){
                gg.base <- gg.base + ggplot2::geom_errorbar(ggplot2::aes_string(x = "time", ymin = "lowerCI.smooth", ymax = "upperCI.smooth", linetype = "labelCI"), width = 1.2)
                gg.base <- gg.base + ggplot2::scale_linetype_manual("",values=setNames(1,labelCI))
            }else{
                gg.base <- gg.base + ggplot2::geom_smooth(eval(parse(text = paste0("ggplot2::aes(x = ","time",", y = ","lowerCI.smooth",", color = ",group.by,", linetype = \"ci\")"))),
                                                          se = FALSE, method = "loess", formula = y~x)
                gg.base <- gg.base + ggplot2::geom_smooth(eval(parse(text = paste0("ggplot2::aes(x = ","time",", y = ","upperCI.smooth",", color = ",group.by,", linetype = \"ci\")"))),
                                                          se = FALSE, method = "loess", formula = y~x)

            }
        }else{
            if(!is.na(alpha)){
                gg.base <- gg.base + ggplot2::geom_errorbar(ggplot2::aes(x = time, ymin = lowerCI, ymax = upperCI, linetype = labelCI), width = 1.2)
                gg.base <- gg.base + ggplot2::scale_linetype_manual("",values=setNames(1,labelCI))

            }else{
                gg.base <- gg.base + ggplot2::geom_segment(ggplot2::aes(x = time, y = lowerCI, xend = timeRight, yend = lowerCI, color = "ci"),
                                                           size = 1.2)
                gg.base <- gg.base + ggplot2::geom_segment(ggplot2::aes(x = time, y = upperCI, xend = timeRight, yend = upperCI, color = "ci"),
                                                           size = 1.2)
            }
        }
    }
    ## estimate
    if(smooth){
        gg.base <- gg.base + ggplot2::geom_smooth(mapping = ggplot2::aes_string(x = "time", y = name.outcome, color = group.by),
                                                  size = 1.5, se = FALSE, method = "loess", formula = y~x)
    }else{
        gg.base <- gg.base + ggplot2::geom_segment(mapping = ggplot2::aes_string(x = "timeRight", y = name.outcome, xend = "time", yend = name.outcome, color = group.by), size = 1.5)
        if("status" %in% names(dataL)){
            dataL$status <- as.character(dataL$status)
            gg.base <- gg.base + ggplot2::geom_point(data = na.omit(dataL),
                                                     mapping = ggplot2::aes_string(x = "time", y = name.outcome, color = group.by, shape = "status"), size = 3)
            gg.base <- gg.base + ggplot2::scale_shape_manual(breaks = c(0,1), values=c(3,18), labels = c("censoring","event"))
        }else{
            gg.base <- gg.base + ggplot2::geom_point(data = dataL,
                                                     mapping = ggplot2::aes_string(x = "time", y = name.outcome, color = group.by), size = 2)
        }
    }
    
    if(group.by=="row"){
        gg.base <- gg.base + ggplot2::labs(color="observation") + ggplot2::theme(legend.key.height=unit(0.1,"npc"),
                                                                                 legend.key.width=unit(0.08,"npc"))
        
        # display only integer values
        uniqueObs <- unique(dataL$row)

        if(length(uniqueObs)==1){
            gg.base <- gg.base + ggplot2::scale_color_discrete(guide=FALSE)
        }
    }

    if(is.na(alpha)[[1]] && (band[[1]] || ci[[1]])){
        indexTempo <- which(c(ci,band)==1)
        if(smooth == FALSE){
            levels.group.by <- levels(dataL[[group.by]])
            n.levels.group.by <- length(levels.group.by)
            gg.base <- gg.base + ggplot2::scale_color_manual("", breaks = c(c("ci","band")[indexTempo],levels.group.by),
                                                             labels = c(c(labelCI,labelBand)[indexTempo],paste0(group.by," ",levels.group.by)),
                                                             values = c(c("grey","black")[indexTempo],
                                                                        grDevices::hcl(h = seq(15, 375, length = n.levels.group.by + 1), l = 65, c = 100)[1:n.levels.group.by]))
        }else{
            gg.base <- gg.base + ggplot2::scale_linetype_manual("", breaks = c("ci","band")[indexTempo],
                                                                labels = c(labelCI,labelBand)[indexTempo],
                                                                values = c("dotdash","longdash")[indexTempo])
        }
    }else if(ci[[1]] && band[[1]]){
        gg.base <- gg.base + ggplot2::guides(linetype = ggplot2::guide_legend(order = 1),
                                             fill = ggplot2::guide_legend(order = 2),
                                             group = ggplot2::guide_legend(order = 3)
                                             )
    }
    gg.base <- gg.base + ggplot2::xlab(xlab) + ggplot2::ylab(ylab) + ggplot2::coord_cartesian(xlim = c(0,max(dataL$timeRight)))
    
    ## export
    ls.export <- list(plot = gg.base,
                      data = dataL)
    
    return(ls.export)
}

#----------------------------------------------------------------------
### autoplot.predictCox.R ends here
