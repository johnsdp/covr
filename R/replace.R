#' @useDynLib covr duplicate_
replacement <- function(name, env = as.environment(-1)) {
  target_value <- get(name, envir = env)
  if (is.function(target_value)) {
    new_value <- trace_calls(target_value)
    attributes(new_value) <- attributes(target_value)

    if (isS4(target_value)) {
      new_value <- asS4(new_value)
    }

    list(
      env = env,
      name = as.name(name),
      orig_value = .Call(duplicate_, target_value),
      target_value = target_value,
      new_value = new_value
    )
  }
}

#' @useDynLib covr reassign_function
replace <- function(replacement) {
  .Call(reassign_function, replacement$name, replacement$env, replacement$target_value, replacement$new_value)
}

#' @useDynLib covr reassign_function
reset <- function(replacement) {
  .Call(reassign_function, replacement$name, replacement$env, replacement$target_value, replacement$orig_value)
}
