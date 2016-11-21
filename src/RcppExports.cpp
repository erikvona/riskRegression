// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// baseHaz_cpp
List baseHaz_cpp(const NumericVector& alltimes, const IntegerVector& status, const NumericVector& eXb, const IntegerVector& strata, bool se, arma::mat data, int nVar, const std::vector<double>& predtimes, const NumericVector& emaxtimes, int nPatients, int nStrata, int cause, bool Efron);
RcppExport SEXP riskRegression_baseHaz_cpp(SEXP alltimesSEXP, SEXP statusSEXP, SEXP eXbSEXP, SEXP strataSEXP, SEXP seSEXP, SEXP dataSEXP, SEXP nVarSEXP, SEXP predtimesSEXP, SEXP emaxtimesSEXP, SEXP nPatientsSEXP, SEXP nStrataSEXP, SEXP causeSEXP, SEXP EfronSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericVector& >::type alltimes(alltimesSEXP);
    Rcpp::traits::input_parameter< const IntegerVector& >::type status(statusSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eXb(eXbSEXP);
    Rcpp::traits::input_parameter< const IntegerVector& >::type strata(strataSEXP);
    Rcpp::traits::input_parameter< bool >::type se(seSEXP);
    Rcpp::traits::input_parameter< arma::mat >::type data(dataSEXP);
    Rcpp::traits::input_parameter< int >::type nVar(nVarSEXP);
    Rcpp::traits::input_parameter< const std::vector<double>& >::type predtimes(predtimesSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type emaxtimes(emaxtimesSEXP);
    Rcpp::traits::input_parameter< int >::type nPatients(nPatientsSEXP);
    Rcpp::traits::input_parameter< int >::type nStrata(nStrataSEXP);
    Rcpp::traits::input_parameter< int >::type cause(causeSEXP);
    Rcpp::traits::input_parameter< bool >::type Efron(EfronSEXP);
    rcpp_result_gen = Rcpp::wrap(baseHaz_cpp(alltimes, status, eXb, strata, se, data, nVar, predtimes, emaxtimes, nPatients, nStrata, cause, Efron));
    return rcpp_result_gen;
END_RCPP
}
// baseHazEfron_survival_cpp
NumericVector baseHazEfron_survival_cpp(int ntimes, IntegerVector ndead, NumericVector risk, NumericVector riskDead);
RcppExport SEXP riskRegression_baseHazEfron_survival_cpp(SEXP ntimesSEXP, SEXP ndeadSEXP, SEXP riskSEXP, SEXP riskDeadSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type ntimes(ntimesSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type ndead(ndeadSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type risk(riskSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type riskDead(riskDeadSEXP);
    rcpp_result_gen = Rcpp::wrap(baseHazEfron_survival_cpp(ntimes, ndead, risk, riskDead));
    return rcpp_result_gen;
END_RCPP
}
// colCumSum
NumericMatrix colCumSum(NumericMatrix x);
RcppExport SEXP riskRegression_colCumSum(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(colCumSum(x));
    return rcpp_result_gen;
END_RCPP
}
// colSumsCrossprod
NumericMatrix colSumsCrossprod(NumericMatrix X, NumericMatrix Y, bool transposeY);
RcppExport SEXP riskRegression_colSumsCrossprod(SEXP XSEXP, SEXP YSEXP, SEXP transposeYSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type X(XSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type Y(YSEXP);
    Rcpp::traits::input_parameter< bool >::type transposeY(transposeYSEXP);
    rcpp_result_gen = Rcpp::wrap(colSumsCrossprod(X, Y, transposeY));
    return rcpp_result_gen;
END_RCPP
}
// calcS0_cpp
double calcS0_cpp(double t, int n, const NumericVector& eventtime, const NumericVector& eXb);
RcppExport SEXP riskRegression_calcS0_cpp(SEXP tSEXP, SEXP nSEXP, SEXP eventtimeSEXP, SEXP eXbSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type t(tSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eventtime(eventtimeSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eXb(eXbSEXP);
    rcpp_result_gen = Rcpp::wrap(calcS0_cpp(t, n, eventtime, eXb));
    return rcpp_result_gen;
END_RCPP
}
// calcS1_cpp
NumericVector calcS1_cpp(double t, int n, int p, const NumericVector& eventtime, const NumericVector& eXb, const arma::mat& X);
RcppExport SEXP riskRegression_calcS1_cpp(SEXP tSEXP, SEXP nSEXP, SEXP pSEXP, SEXP eventtimeSEXP, SEXP eXbSEXP, SEXP XSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type t(tSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< int >::type p(pSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eventtime(eventtimeSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eXb(eXbSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type X(XSEXP);
    rcpp_result_gen = Rcpp::wrap(calcS1_cpp(t, n, p, eventtime, eXb, X));
    return rcpp_result_gen;
END_RCPP
}
// calcE_cpp
List calcE_cpp(double t, int n, int p, const NumericVector& eventtime, const NumericVector& eXb, const arma::mat& X);
RcppExport SEXP riskRegression_calcE_cpp(SEXP tSEXP, SEXP nSEXP, SEXP pSEXP, SEXP eventtimeSEXP, SEXP eXbSEXP, SEXP XSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type t(tSEXP);
    Rcpp::traits::input_parameter< int >::type n(nSEXP);
    Rcpp::traits::input_parameter< int >::type p(pSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eventtime(eventtimeSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type eXb(eXbSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type X(XSEXP);
    rcpp_result_gen = Rcpp::wrap(calcE_cpp(t, n, p, eventtime, eXb, X));
    return rcpp_result_gen;
END_RCPP
}
// calcU_cpp
arma::mat calcU_cpp(const arma::mat& newX, const NumericVector& newStatus, int newN, const IntegerVector& IndexNewT, const arma::mat& ENewT, int p, bool aggregate);
RcppExport SEXP riskRegression_calcU_cpp(SEXP newXSEXP, SEXP newStatusSEXP, SEXP newNSEXP, SEXP IndexNewTSEXP, SEXP ENewTSEXP, SEXP pSEXP, SEXP aggregateSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type newX(newXSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type newStatus(newStatusSEXP);
    Rcpp::traits::input_parameter< int >::type newN(newNSEXP);
    Rcpp::traits::input_parameter< const IntegerVector& >::type IndexNewT(IndexNewTSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type ENewT(ENewTSEXP);
    Rcpp::traits::input_parameter< int >::type p(pSEXP);
    Rcpp::traits::input_parameter< bool >::type aggregate(aggregateSEXP);
    rcpp_result_gen = Rcpp::wrap(calcU_cpp(newX, newStatus, newN, IndexNewT, ENewT, p, aggregate));
    return rcpp_result_gen;
END_RCPP
}
// rowCumSum
NumericMatrix rowCumSum(NumericMatrix x);
RcppExport SEXP riskRegression_rowCumSum(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(rowCumSum(x));
    return rcpp_result_gen;
END_RCPP
}
// rowSumsCrossprod
NumericMatrix rowSumsCrossprod(NumericMatrix X, NumericMatrix Y, bool transposeY);
RcppExport SEXP riskRegression_rowSumsCrossprod(SEXP XSEXP, SEXP YSEXP, SEXP transposeYSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type X(XSEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type Y(YSEXP);
    Rcpp::traits::input_parameter< bool >::type transposeY(transposeYSEXP);
    rcpp_result_gen = Rcpp::wrap(rowSumsCrossprod(X, Y, transposeY));
    return rcpp_result_gen;
END_RCPP
}
