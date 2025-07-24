# secrets.R
# functions for managing secrets


#' check_passwd
#'
#' Check a provided password against a hashed version
#'
#' @param hashed_passwd The hashed password to check against
#' @param passwd The password to check
#' @param algo The hashing algorithm to use
#'
#' @return TRUE if the password matches the hashed password, FALSE otherwise
#'
#' @export
#' @importFrom digest digest
#' @importFrom askpass askpass
check_passwd <- function(hashed_passwd, passwd = NULL, algo = "sha256")
{
  if(is.null(passwd))
    passwd <- askpass("Enter password: ")

  digest(passwd, algo = algo, serialize = FALSE) == hashed_passwd
}
